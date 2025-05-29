# frozen_string_literal: true

class Api::V1::Users::MeController < ApplicationController
  skip_before_action :validate_email_confirmation

  def show; end

  def update
    if @current_user.update(user_params)
      render :show
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
