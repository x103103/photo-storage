class CreateStorageFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :storage_files do |t|
      t.string :name

      t.timestamps
    end
  end
end
