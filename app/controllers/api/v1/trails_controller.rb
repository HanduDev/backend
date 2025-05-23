# frozen_string_literal: true

require 'json'

class Api::V1::TrailsController < ApplicationController
  before_action :set_trail, only: %i[show destroy]

  def index
    @trails = @current_user.trails.includes(:lessons).order(created_at: :desc)
  end

  def create
    json_params = JSON.parse(trail_params.to_json)

    ::CreateTrailWorker.perform_async(json_params, @current_user.id)

    render json: { message: I18n.t('messages.trail_created') }, status: :created
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
end
