class BloodSugar < ApplicationRecord
  belongs_to :device
  after_create :broadcast

  def broadcast
    time = (self.created_at + 1.hours).to_datetime.strftime('%Q')
    GraphingChannel.broadcast_to(self.device, {level: self.device.blood_sugars.last.level, time: time})
  end
end
