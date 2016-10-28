class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:patient, :admin, :doctor]

  has_one :device

  after_create :create_device_for_user

  protected

  def create_device_for_user
    self.device = Device.create
  end
end
