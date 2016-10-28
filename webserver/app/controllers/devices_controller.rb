class DevicesController < ApplicationController
  load_and_authorize_resource through: :current_user, singleton: true

  def show
    @device = current_user.device
    @chart_data = {}
    @device.blood_sugars.each do |bs|
      @chart_data[bs.created_at] = bs.level
    end
  end

end
