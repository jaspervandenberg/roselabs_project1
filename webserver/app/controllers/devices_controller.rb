class DevicesController < ApplicationController

  def index
    @devices = Device.ordered
  end

  def new
    @device = Device.new
  end

  def create
    if @device = Device.create
      redirect_to devices_path, notice: 'Aanmaken gelukt'
    else
      render 'new'
    end
  end

  def update
    if @device = Device.update_attributes(device_params)
      redirect_to edit_device_path, notice: 'Updaten gelukt'
    else
      render 'edit'
    end
  end

  def destroy
    Device.find_by(params[:id]).destroy
    redirect_to devices_path, notice: 'Device verwijderd'
  end

  protected

  def device_params
    params.require(:device).permit(

    )
  end


end
