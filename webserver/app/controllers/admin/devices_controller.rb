class Admin::DevicesController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @devices = Device.ordered
  end

  def new
    @device = Device.new
    @users = User.all
  end

  def create
    if @device = Device.create(device_params)
      redirect_to admin_devices_path, notice: 'Aanmaken gelukt'
    else
      render 'new'
    end
  end

  def update
    if @device = Device.update_attributes(device_params)
      redirect_to edit_admin_device_path, notice: 'Updaten gelukt'
    else
      render 'edit'
    end
  end

  def destroy
    Device.find(params[:id]).destroy
    redirect_to admin_devices_path, notice: 'Device verwijderd'
  end

  protected

  def device_params
    params.require(:device).permit(
      :user_id
    )
  end


end
