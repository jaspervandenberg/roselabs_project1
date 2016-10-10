module AESDecryptor
  extend ActiveSupport::Concern

  # Requires an iv and body encoded in Base64
  # Device needs to be an activerecord object
  def decrypt_body(body, iv, device)
    cipher = OpenSSL::Cipher::AES128.new(:CBC)
    cipher.decrypt
    cipher.key = Base64.decode64(device.key)
    cipher.iv = Base64.decode(iv)

    return cipher.update(Base64.decode(body)) + cipher.final
  end

  # Device needs to be an activerecord object
  def encrypt_body(body, device)
    cipher = OpenSSL::Cipher::AES128.new(:CBC)
    cipher.encrypt
    cipher.key = Base64.decode64(device.key)
    iv = cipher.random_iv

    return {body: Base64.encode64(cipher.update(body) + cipher.final).encode('utf-8'), iv: Base64.encode64(iv).encode('utf-8')}
  end

end
