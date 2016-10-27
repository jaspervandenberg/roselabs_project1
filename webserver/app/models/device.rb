class Device < ApplicationRecord
  include SecureUID
  has_many :blood_sugars
  belongs_to :firmware

  after_create :set_uid
  after_create :set_key

  scope :ordered, -> {
    order(:id)
  }

  protected

  def set_uid
    uid = generate_secure_uid
    unless Device.find_by_uid(uid).blank?
      uid = Device.set_uid
    end

    self.uid = uid
    self.save
  end

  def set_key
    key = OpenSSL::Cipher::AES128.new(:CBC).random_key
    key = Base64.strict_encode64(key)
    self.key = key
    self.save
  end
end
