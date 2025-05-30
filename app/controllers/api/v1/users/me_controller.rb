# frozen_string_literal: true

class Api::V1::Users::MeController < ApplicationController
  skip_before_action :validate_email_confirmation

  def show; end

  def update
    ActiveRecord::Base.transaction do
      if @current_user.update(user_params.except(:email))
        send_email_confirmation if should_send_email_confirmation?
        render :show
      else
        render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :photo)
  end

  def send_email_confirmation
    @current_user.send_email_confirmation(email: user_params[:email])
  end

  def should_send_email_confirmation?
    user_params[:email].present? && user_params[:email] != @current_user.email
  end
end
