class TrailChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_channel_trail_#{params[:user_id]}"
  end

  def unsubscribed
    stop_all_streams
  end
end
