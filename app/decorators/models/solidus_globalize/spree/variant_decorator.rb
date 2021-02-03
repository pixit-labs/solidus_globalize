# frozen_string_literal: true

module SolidusGlobalize
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.class_eval do
          def self.translated_attribute_names
            ::Spree::Product.translated_attribute_names.collect{|name| :"product_#{name}" } + ::Spree::OptionValue.translated_attribute_names.collect{|name| :"option_values_#{name}" }
          end

          def self.ransack(params = {}, options = {})

            params ||= {}
            names = params.keys

            names.each do |n|
              translated_attribute_names.each do |t|
                if n.to_s.starts_with? t.to_s
                  params[n.to_s.gsub("product", "product_translations")] = params[n]
                  params.delete n
                end
              end
            end

            super(params, options)
          end

          alias :search :ransack unless respond_to? :search
        end

      end
        ::Spree::Variant.prepend self
    end
  end
end
