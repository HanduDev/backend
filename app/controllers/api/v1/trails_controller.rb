# frozen_string_literal: true

require 'json'

class Api::V1::TrailsController < ApplicationController
  before_action :set_trail, only: %i[show destroy]

  def index
    @trails = @current_user.trails.includes(:lessons)
  end

  def create
    ai_service = GoogleAiService.new(user: @current_user)

    @trail = @current_user.trails.new(
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
    @trail.lessons.create!(lessons_response.map(&:to_h))

    render :create, status: :created
  rescue JSON::ParserError => e
    render json: { message: I18n.t('errors/messages.ai_response_invalid') }, status: :internal_server_error
  end

  def show; end

  def destroy
    @trail.destroy!
  end

  private

  def set_trail
    @trail = @current_user.trails.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: I18n.t('errors/messages.trail_not_found') }, status: :not_found
  end

  def trail_params
    params.require(:trail).permit(:language, :name, :description, :started_at,
                                  :level, :time_to_learn, :time_to_study,
                                  developments: [], themes: [])
  end

  def sanitize_json_string(str)
    str.encode('UTF-8', invalid: :replace, undef: :replace)
      .gsub(/[[:cntrl:]&&[^\n\r\t]]/, '') # remove caracteres de controle ASCII inválidos
  end
end
