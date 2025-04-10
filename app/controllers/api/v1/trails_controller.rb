# frozen_string_literal: true

class Api::V1::TrailsController < ApplicationController
  before_action :set_trail, only: %i[show destroy]

  def index
    @trails = @current_user.trails
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
end
