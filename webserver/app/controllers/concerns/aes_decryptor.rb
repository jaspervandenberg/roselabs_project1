module AESDecryptor
  extend ActiveSupport::Concern

  # Requires an iv and body encoded in Base64
  # Device needs to be an activerecord object
  def decrypt_body(body, iv, device)
    cipher = OpenSSL::Cipher::AES128.new(:CBC)
    cipher.decrypt
    cipher.key = Base64.decode64(device.key)
    cipher.iv = iv
    cipher.padding = 0

    return cipher.update(Base64.decode64(body)) + cipher.final
  end

  # Device needs to be an activerecord object
  def encrypt_body(body, device)
    cipher = OpenSSL::Cipher::AES128.new(:CBC)
    cipher.encrypt
    cipher.key = Base64.decode64(device.key)
    iv = cipher.random_iv
    digest = OpenSSL::Digest.new('sha256')

    return {body: Base64.strict_encode64(cipher.update(body) + cipher.final), iv: Base64.strict_encode64(iv)}
  end

  def calculate_hmac(body, device)
    digest = OpenSSL::Digest.new('sha256')
    return Base64.strict_encode64(OpenSSL::HMAC.digest(digest, Base64.decode64(device.key), body))
  end

end
