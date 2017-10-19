# frozen_string_literal: true

module Attachy
  class File < ::ActiveRecord::Base
    self.table_name = 'attachy_files'

    before_destroy :destroy_file

    after_create :remove_tmp_tag

    belongs_to :attachable, polymorphic: true

    validates :format, :height, :public_id, :resource_type, :scope, :version, :width, presence: true

    def transform(options = {})
      options = options.reverse_merge(
        format:    format,
        public_id: public_id,
        secure:    true,
        sign_url:  true,
        version:   version
      )

      if options[:crop] == :none
        options.delete :crop
        options.delete :height
        options.delete :width
      elsif options[:crop].blank?
        options[:crop] = :fill
      end

      options
    end

    def url(options = {})
      Cloudinary::Utils.cloudinary_url public_id, transform(options)
    end

    def self.config
      ::Rails.application.config_for :attachy
    end

    def self.default
      image = config.dig('default', 'image')

      return if image.nil?

      new image
    end

    private

    def destroy_file
      Cloudinary::Uploader.destroy public_id
    end

    def remove_tmp_tag
      Cloudinary::Uploader.remove_tag TMP_TAG, [public_id]
    end

    def h
      ActionController::Base.helpers
    end
  end
end
