class Api::V1::FirmwaresController < Api::V1::ApplicationController
  include AESDecryptor

  def index
    @firmware = Firmware.ordered.last
    handle_headers if @device.present?
    file = File.open(@firmware.file.path, 'rb')
    content = file.read
    render text: Base64.encode64(content), status: 200
    file.close()
  end

  def show
    @firmware = Firmware.ordered.last
    handle_headers if @device.present?
    file = File.open(@firmware.file.path, 'rb')
    content = file.read
    render text:  Base64.encode64(content), status: 200
    file.close()
  end

  protected

  def handle_headers
    encrypted_data = encrypt_body(@firmware.checksum, @device)
    response.headers['encrypted_hash'] = encrypted_data[:body]
    response.headers['iv'] = encrypted_data[:iv]
  end
end
