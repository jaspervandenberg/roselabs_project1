class CreateBloodSugars < ActiveRecord::Migration[5.0]
  def change
    create_table :blood_sugars do |t|
      t.string :level
      t.references :device, foreign_key: true

      t.timestamps
    end
  end
end
