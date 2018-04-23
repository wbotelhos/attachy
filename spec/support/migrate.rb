# frozen_string_literal: true

require File.expand_path('../../lib/generators/attachy/templates/db/migrate/create_attachy_files_table.rb', __dir__)

CreateAttachyFilesTable.new.change
CreateUsersTable.new.change
CreateAdminUsersTable.new.change
