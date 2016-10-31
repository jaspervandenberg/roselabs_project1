class DevicesController < ApplicationController
  load_and_authorize_resource through: :current_user, singleton: true

  def show
    unless current_user.admin?
      @device = current_user.device
      @chart_data = {}
      @device.blood_sugars.limit(10).each do |bs|
        @chart_data[bs.created_at] = bs.level
      end
      @bs_avg = @device.last_avg_blood_sugars(10).to_i
    else
      redirect_to root_path, notice: 'admin cant look at a device'
    end
  end

end
