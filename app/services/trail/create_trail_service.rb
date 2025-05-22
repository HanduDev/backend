# frozen_string_literal: true

class Trail::CreateTrailService < Trail::TrailService
  def initialize(trail_params:, user:)
    @trail_params = trail_params
    @user = user
  end

  def call
    initialize_trail

    trail_response = generate_json_response(prompt: trail_prompt.prompt)

    @trail.assign_attributes(trail_response)
    @trail.save!

    ::Trail::CreateLessonsService.new(trail: @trail, user: @user).call

    @trail
  end

  private

  def initialize_trail
    @trail = @user.trails.new(@trail_params.merge(name: 'Processing...', description: 'Processing...'))

    raise(ActiveRecord::RecordInvalid, @trail) unless @trail.valid?
  end

  def trail_prompt
    TrailPrompt.new(trail: @trail)
  end
end
