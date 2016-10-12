class CreateFirmwares < ActiveRecord::Migration[5.0]
  def change
    create_table :firmwares do |t|
      t.string :version
      t.string :file_hash

      t.timestamps
    end
  end
end
