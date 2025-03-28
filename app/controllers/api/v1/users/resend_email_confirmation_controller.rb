# frozen_string_literal: true

class Api::V1::Users::ResendEmailConfirmationController < ApplicationController
  skip_before_action :validate_email_confirmation

  def create
    if @current_user.confirmed_email_at.present?
      return render json: { message: I18n.t('modules/users/errors/messages.email_already_confirmed') },
                    status: :conflict
    end

    @current_user.send_email_confirmation

    render json: { message: I18n.t('modules/users/messages.email_confirmation_sent') }, status: :ok
  end
end
