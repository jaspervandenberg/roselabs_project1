class Firmware < ApplicationRecord
  has_attached_file :file
  do_not_validate_attachment_file_type :file

  after_save :set_hash

  validates :file, presence: true

  scope :ordered, -> {
    order(:id)
  }

  protected

  def set_hash
    checksum = Digest::SHA1.file(self.file.path).base64digest
    self.update_columns(checksum: checksum)
  end

end
