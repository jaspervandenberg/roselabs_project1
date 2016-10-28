class BloodSugarsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @blood_sugars = BloodSugar.all.limit(10)
  end

end
