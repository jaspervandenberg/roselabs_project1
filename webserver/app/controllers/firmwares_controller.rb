class FirmwaresController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @firmwares = Firmware.all
  end

end
