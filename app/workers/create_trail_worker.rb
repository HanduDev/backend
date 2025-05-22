# frozen_string_literal: true
class CreateTrailWorker
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(params, user_id)
    trail_params = params.with_indifferent_access

    user = User.find(user_id)
    sleep(4)

    trail = ::Trail::CreateTrailService.new(trail_params: trail_params, user: user).call

    language = trail.lang

    trail_response = {
      id: trail.id,
      name: trail.name,
      description: trail.description,
      language: {
        name: language.name,
        code: language.acronym
      },
      progress: trail.progress / 100.0
    }

    ActionCable.server.broadcast("user_channel_trail_#{user_id}", { trail: trail_response })
  rescue => e
    ActionCable.server.broadcast("user_channel_trail_#{user.id}", { error: e.message })
    Rails.logger.error(e.message)
  end
end
