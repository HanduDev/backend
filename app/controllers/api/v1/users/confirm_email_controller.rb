# frozen_string_literal: true

class Api::V1::Users::ConfirmEmailController < ApplicationController
  skip_before_action :validate_email_confirmation

  def create
    code = confirm_email_params[:code]

    unless @current_user.email_confirmation_code_valid?(code: code)
      return render json: { message: I18n.t('modules/users/errors/messages.invalid_confirmation_code') },
                    status: :unprocessable_entity
    end

    if confirm_email_params[:email].present? && confirm_email_params[:email] != @current_user.email
      @current_user.update!(confirmed_email_at: Time.current, email: confirm_email_params[:email],)
    else
      @current_user.update!(confirmed_email_at: Time.current)
    end
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private

  def confirm_email_params
    params.require(:user).permit(:code, :email)
  end
end
