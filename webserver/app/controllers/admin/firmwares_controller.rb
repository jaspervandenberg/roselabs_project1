class Admin::FirmwaresController < Admin::ApplicationController
  def index
    @firmwares = Firmware.ordered
  end

  def show
    @firmware = Firmware.find(params[:id])
  end

  def create
    if @firmware = Firmware.create(firmware_params)
      redirect_to admin_firmwares_path, notice: 'Firmware created'
    else
      render 'new'
    end
  end

  def new
    @firmware = Firmware.new
  end

  def destroy
    @firmware = Firmware.find(params[:id])
    @firmware.destroy
    redirect_to admin_firmwares_path, notice: 'Firmware destroyed'
  end

  protected

  def firmware_params
    params.require(:firmware).permit(
      :file,
      :version
    )
  end
end
