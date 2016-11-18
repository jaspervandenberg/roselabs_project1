class GraphingChannel < ApplicationCable::Channel
  def subscribed
    device = current_user.device
    stream_for device
  end
end
