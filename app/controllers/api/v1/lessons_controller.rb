# frozen_string_literal: true

class Api::V1::LessonsController < ApplicationController
  before_action :set_lesson, only: %i[show update destroy]

  def index
    @lessons = @current_user.lessons
  end

  def show; end

  def update
    @lesson.update!(lesson_params)
  end

  def destroy
    @lesson.destroy!
  end

  private

  def set_lesson
    @lesson = @current_user.lessons.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: I18n.t('errors/messages.lesson_not_found') }, status: :not_found
  end

  def lesson_params
    params.require(:lesson).permit(:has_finished)
  end
end
