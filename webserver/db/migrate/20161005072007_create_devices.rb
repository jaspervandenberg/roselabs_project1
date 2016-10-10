class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :uid
      t.string :key

      t.timestamps
    end
  end
end
