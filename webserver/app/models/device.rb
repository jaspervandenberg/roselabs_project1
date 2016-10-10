class Device < ApplicationRecord
  include SecureUID

  after_create :set_uid
  after_create :set_key

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
    key = Base64.encode64(key).encode('utf-8')
    self.key = key
    self.save
  end
end
