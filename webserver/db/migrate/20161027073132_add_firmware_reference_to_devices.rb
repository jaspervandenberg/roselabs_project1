class AddFirmwareReferenceToDevices < ActiveRecord::Migration[5.0]
  def change
    add_reference :devices, :firmware, foreign_key: true
  end
end
