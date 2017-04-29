# frozen_string_literal: true

module Attachy
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :format   , type: :string, default: :jpg
    argument :public_id, type: :string, default: :default
    argument :version  , type: :string, default: 1

    desc 'configure Attachy'

    def create_config
      template 'config/attachy.yml.erb', 'config/attachy.yml'
    end

    def create_cors
      template 'public/cloudinary_cors.html', 'public/cloudinary_cors.html'
    end

    def create_migration
      version = Time.zone.now.strftime('%Y%m%d%H%M%S')

      template 'db/migrate/create_attachy_files_table.rb', "db/migrate/#{version}_create_attachy_files_table.rb"
    end
  end
end
