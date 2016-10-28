class AddUserReferenceToDevices < ActiveRecord::Migration[5.0]
  def change
    add_reference :devices, :user, foreign_key: true
  end
end
