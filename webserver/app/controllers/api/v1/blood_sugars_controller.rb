class Api::V1::BloodSugarsController < Api::V1::ApplicationController
  include AESDecryptor

  before_action :load_device

  def index
  end

  def create
    body = decrypt_body(request.body, request.headers['iv'], device)
    device.blood_sugars.create()
  end

  def load_device
    device = Device.find_by_uid(request.headers['uid'])

    if device.nil?
      render nothing: true, status: 201
    end
  end
end
