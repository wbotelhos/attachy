class CreateAttachyFilesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :attachy_files do |t|
      t.integer :height       , null: false
      t.integer :width        , null: false
      t.string  :format       , null: false
      t.string  :public_id    , null: false
      t.string  :resource_type, null: false, default: :image
      t.string  :scope        , null: false
      t.string  :version      , null: false

      t.references :attachable, polymorphic: true

      t.timestamps null: false
    end

    add_index :attachy_files, [:attachable_type, :attachable_id, :scope], name: :index_attachy_files_on_attachable_and_scope
  end
end
