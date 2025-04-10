# frozen_string_literal: true

class Api::V1::TrailsController < ApplicationController
  before_action :set_trail, only: %i[show destroy]

  def index
    @trails = @current_user.trails
  end

  def create
    prompt = TrailPrompt.new(
      language: Language.new(acronym: trail_params[:language])
    )

    raise(CustomException, prompt.errors.full_messages.to_sentence) unless prompt.errors.empty?

    ai_service = GoogleAiService.new(user: @current_user)
    ai_response = ai_service.generate_text(prompt: prompt.prompt)
                            .gsub('```json', '')
                            .gsub('```', '')

    ai_response = JSON.parse(ai_response)

    @trail = @current_user.trails.create!(
      ai_response.merge(language: trail_params[:language])
    )

    render :show, status: :created
  rescue JSON::ParserError
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
    params.require(:trail).permit(:language)
  end
end
