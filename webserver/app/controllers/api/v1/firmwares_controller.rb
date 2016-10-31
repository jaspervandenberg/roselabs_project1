class Api::V1::FirmwaresController < Api::V1::ApplicationController
  include AESDecryptor

  before_action :load_firmware
  before_action :blank_if_up_to_date

  def index
    if params[:hmac].present?
      render text: calculate_hmac(@plain_file, @device)
    else
      send_file @firmware.file.path
    end
  end

  def show
    index
  end

  protected

  def load_firmware
    @firmware = Firmware.ordered.last
    file = File.open(@firmware.file.path, 'rb')
    @plain_file = file.read
    @base64_content = Base64.strict_encode64(@plain_file)
    file.close()
  end

  def blank_if_up_to_date
    if request.headers['Last-Checksum'] == @firmware.checksum
      render(nothing: true, status: 204) and return
    end
  end
end
