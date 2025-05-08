class Api::V1::Trails::CheckAnswerController < ApplicationController
  before_action :set_lesson

  def update
    @answer = @lesson.check_answer(check_answer_params[:answer])

    @lesson.update!(has_finished: true, finished_at: Time.current) if @answer
  end

  private

  def check_answer_params
    params.expect(check_answer: [:answer])
  end

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end
end
