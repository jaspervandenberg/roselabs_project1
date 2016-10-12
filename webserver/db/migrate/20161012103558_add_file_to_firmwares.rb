class AddFileToFirmwares < ActiveRecord::Migration[5.0]
  def change
    add_attachment :firmwares, :file
  end
end
