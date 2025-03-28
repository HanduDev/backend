# frozen_string_literal: true

class Api::V1::Users::ConfirmEmailController < ApplicationController
  skip_before_action :validate_email_confirmation

  def create
    if @current_user.confirmed_email_at.present?
      return render json: { message: I18n.t('modules/users/errors/messages.email_already_confirmed') },
                    status: :conflict
    end

    code = confirm_email_params[:code]

    unless @current_user.email_confirmation_code_valid?(code: code)
      return render json: { message: I18n.t('modules/users/errors/messages.invalid_confirmation_code') },
                    status: :unprocessable_entity
    end

    @current_user.update!(confirmed_email_at: Time.current)
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private

  def confirm_email_params
    params.require(:user).permit(:code)
  end
end
