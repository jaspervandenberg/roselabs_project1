class DevicesController < ApplicationController
  load_and_authorize_resource through: :current_user, singleton: true

  def show
    unless current_user.admin?
      @device = current_user.device
      @chart_data = {}
      @device.blood_sugars.each do |bs|
        @chart_data[bs.created_at] = bs.level
      end
    else
      recirect_to root_path, notice: 'admin cant look at a device'
    end
  end

end
