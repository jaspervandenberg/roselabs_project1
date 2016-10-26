class Api::V1::FirmwaresController < Api::V1::ApplicationController
  include AESDecryptor

  def index
    @firmware = Firmware.ordered.last
    file = File.open(@firmware.file.path, 'rb')
    content = Base64.strict_encode64(file.read)
    file.close()

    unless @device.nil?
      encrypted_data = encrypt_body(Base64.strict_decode64(@firmware.checksum), @device)

      json_content = {base64_encrypted_checksum: encrypted_data[:body], base64_file: content, base64_iv: encrypted_data[:iv]}
      render text:  JSON.generate(json_content), status: 200
    else
      render text: JSON.generate(base64_file: content)
    end
  end

  def show
    @firmware = Firmware.ordered.last
    file = File.open(@firmware.file.path, 'rb')
    content = Base64.strict_encode64(file.read)
    file.close()

    unless @device.nil?
      encrypted_data = encrypt_body(@firmware.checksum, @device)

      json_content = {base64_encrypted_checksum: encrypted_data[:body], base64_file: content, base64_iv: encrypted_data[:iv]}
      render text:  JSON.generate(json_content), status: 200
    else
      render text: JSON.generate(base64_file: content)
    end
  end
end
