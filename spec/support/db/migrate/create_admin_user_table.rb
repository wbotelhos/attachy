# frozen_string_literal: true

class CreateAdminUsersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users do |t|
      t.string :name, null: false
    end
  end
end
