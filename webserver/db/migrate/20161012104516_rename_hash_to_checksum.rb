class RenameHashToChecksum < ActiveRecord::Migration[5.0]
  def change
    rename_column :firmwares, :file_hash, :checksum
  end
end
