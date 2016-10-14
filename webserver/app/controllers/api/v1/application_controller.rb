class Api::V1::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :load_device

  protected

  def load_device
    @device = Device.find_by_uid(request.headers['uid'])
  end
end
