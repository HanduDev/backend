# frozen_string_literal: true

require 'json'

class CreateTrailWorker
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(params, user_id)
    trail_params = params.with_indifferent_access

    Rails.logger.info("Broadcasting to: user_channel_trail_#{user_id}")

    user = User.find(user_id)
    sleep(4)

    ActiveRecord::Base.transaction do
      ai_service = GoogleAiService.new(user: user)

      @trail = user.trails.new(
        trail_params.merge(name: 'Processing...', description: 'Processing...')
      )

      prompt = TrailPrompt.new(
        trail: @trail
      )

      raise(ActiveRecord::RecordInvalid, @trail) unless @trail.valid?

      ai_response = ai_service.generate_text(prompt: prompt.prompt)
                              .gsub('```json', '')
                              .gsub('```', '')
                              .strip

      ai_response = JSON.parse(sanitize_json_string(ai_response))

      @trail.assign_attributes(ai_response)
      @trail.save!

      lessons_prompt = LessonsPrompt.new(
        trail: @trail
      )

      ai_lessons_response = ai_service.generate_text(prompt: lessons_prompt.prompt)
                                      .gsub('```json', '')
                                      .gsub('```', '')
                                      .strip

      lessons_response = JSON.parse(sanitize_json_string(ai_lessons_response))

      lessons_response_without_options = lessons_response.map do |lesson|
        if lesson['options'].present?
          lesson.except('options')
        else
          lesson
        end
      end

      lessons = @trail.lessons.create!(lessons_response_without_options.map(&:to_h))

      options = []

      lessons.each_with_index do |lesson, index|
        next if lessons_response[index]['options'].blank?

        options << lessons_response[index]['options'].map do |option|
          option['lesson_id'] = lesson.id
          option
        end
      end

      Option.create!(options)
    end

    language = @trail.lang

    trail_response = {
      id: @trail.id,
      name: @trail.name,
      description: @trail.description,
      language: {
        name: language.name,
        code: language.acronym
      },
      progress: @trail.progress / 100.0
    }

    ActionCable.server.broadcast("user_channel_trail_#{user_id}", { trail: trail_response })
  rescue => e
    ActionCable.server.broadcast("user_channel_trail_#{user.id}", { error: e.message })
    Rails.logger.error(e.message)
  end

  private

  def sanitize_json_string(str)
    str.encode('UTF-8', invalid: :replace, undef: :replace)
      .gsub(/[[:cntrl:]&&[^\n\r\t]]/, '')
  end
end
