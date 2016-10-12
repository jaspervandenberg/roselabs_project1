class Api::V1::FirmwaresController < Api::V1::ApplicationController
  include AESDecryptor

  def index
    @firmware = Firmware.ordered.last
    handle_headers if @device.present?
    send_file(@firmware.file.path)
  end

  def show
    @firmware = Firmware.find(params[:id])
    handle_headers if @device.present?
    send_file(@firmware.file.path)
  end

  protected

  def handle_headers
    encrypted_data = encrypt_body(@firmware.checksum, @device)
    response.headers['encrypted_hash'] = encrypted_data[:body]
    response.headers['iv'] = encrypted_data[:iv]
  end
end
