class Api::V1::DevicesController < Api::V1::ApplicationController
  include AESDecryptor
  before_action :load_device

  def create
  end

  def update
    @body = decrypt_body(request.body, request.headers['vi'], device)
    device.update_attributes(device_params)
  end

  protected

  def load_device
    device = Device.find_by_uid(request.headers['uid'])

    if device.nil?
      render nothing: true, status: 201
    end
  end

  def device_params
    @body.require(:device).permit(
      blood_sugars: [
        :level
      ]
    )
  end
end