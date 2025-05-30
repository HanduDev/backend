# frozen_string_literal: true

class Api::V1::Users::ResendEmailConfirmationController < ApplicationController
  skip_before_action :validate_email_confirmation

  def create
    @current_user.send_email_confirmation(resend_email_confirmation_params)

    render json: { message: I18n.t('modules/users/messages.email_confirmation_sent') }, status: :ok
  end

  private

  def resend_email_confirmation_params
    params.require(:user).permit(:email)
  end
end
