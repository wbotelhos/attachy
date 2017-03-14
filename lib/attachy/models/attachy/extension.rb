module Attachy
  module Extension
    extend ActiveSupport::Concern

    included do
      private

      def attachy_class
        Attachy::File
      end

      def attachies_for(data, scope)
        json = JSON.parse(data, symbolize_names: true)

        [json].flatten.map do |data|
          if data[:id]
            attachy_class.find data[:id]
          else
            attachy_class.new data.slice(*fields).merge(scope: scope)
          end
        end
      end

      def fields
        @fields ||= attachy_class.column_names.map(&:to_sym)
      end
    end

    class_methods do
      def has_attachment(scope, options = {})
        define_attachy scope, options.merge(multiple: false)
      end

      def has_attachments(scope, options = {})
        define_attachy scope, options.merge(multiple: true)
      end

      private

      def define_attachy(scope, options)
        association = "#{scope}_files"

        has_many association.to_sym,
          -> { where scope: scope },
          as: :attachable,
          class_name: Attachy::File,
          dependent: :destroy

        define_method scope do
          value = send(association)

          return value if options[:multiple]

          return Attachy::File.default if value.blank?

          value.last
        end

        define_method "#{scope}=" do |data|
          attachies = attachies_for(data, scope)

          if attachies.present?
            send "#{association}=", attachies
          else
            send(association).destroy_all
          end
        end

        define_method "#{scope}?" do
          send("#{scope}_files").present?
        end

        define_method "#{scope}_metadata" do
          options.merge scope: scope
        end
      end
    end
  end
end
