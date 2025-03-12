# frozen_string_literal: true

class Api::V1::Authentication::GoogleController < ApplicationController
  skip_before_action :authenticate_request

  def create
    google_auth_data = GoogleAuthService.authenticate(token: register_params[:token])

    @user = User.find_by(email: google_auth_data['email']) || User.find_by(google_id: google_auth_data['sub'])

    if @user.present?
      @token = JwtService.encode(user_id: @user.id)

      return
    end

    if @user.blank?
      @user = User.create!(
        email: google_auth_data['email'],
        google_id: google_auth_data['sub'],
        full_name: "#{google_auth_data['given_name']} #{google_auth_data['family_name']}",
        password: "Secure_Random_#{SecureRandom.hex(10)}",
        photo_url: google_auth_data['picture']
      )
    end

    @token = JwtService.encode(user_id: @user.id)

    render :create, status: :created
  rescue StandardError
    render json: { message: I18n.t('errors/messages.invalid_login') }, status: :unauthorized
  end

  private

  def register_params
    params.require(:user).permit(:token)
  end
end
