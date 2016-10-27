class Api::V1::FirmwaresController < Api::V1::ApplicationController
  include AESDecryptor

  before_action :load_firmware
  before_action :blank_if_up_to_date

  def index
    if @device.present?
      encrypted_data = encrypt_body(Base64.strict_decode64(@firmware.checksum), @device)

      json_content = {base64_encrypted_checksum: encrypted_data[:body], base64_file: @content, base64_iv: encrypted_data[:iv]}
      json_content = JSON.generate(json_content)

      @device.update_attribute(:firmware_id, @firmware.id)

      render text: json_content, status: 200
    else
      render text: JSON.generate(base64_file: @content)
    end
  end

  def show
    index
  end

  protected

  def load_firmware
    @firmware = Firmware.ordered.last
    file = File.open(@firmware.file.path, 'rb')
    @content = Base64.strict_encode64(file.read)
    file.close()
  end

  def blank_if_up_to_date
    if request.headers['Last-Checksum'] == @firmware.checksum
      render(nothing: true, status: 204) and return
    end
  end
end
