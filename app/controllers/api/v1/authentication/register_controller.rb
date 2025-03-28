# frozen_string_literal: true

class Api::V1::Authentication::RegisterController < ApplicationController
  skip_before_action :authenticate_request

  def create
    @user = User.find_by(email: register_params[:email])

    if @user.present?
      return render json: { message: I18n.t('modules/users/errors/messages.user_already_exists') },
                    status: :conflict
    end

    @user = User.create!(register_params)

    @token = JwtService.encode(user_id: @user.id)

    @user.send_email_confirmation

    render :create, status: :created
  end

  private

  def register_params
    params.require(:user).permit(:password, :full_name, :email)
  end
end
