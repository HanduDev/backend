# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request
  before_action :validate_email_confirmation, if: -> { @current_user.present? }
  before_action :set_paper_trail_whodunnit, if: -> { @current_user.present? }

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split.last if header

    begin
      @decoded = JwtService.decode(header)

      if @decoded.blank?
        return render json: { message: I18n.t('errors/messages.invalid_session') },
                      status: :unauthorized
      end

      @current_user = User.find(@decoded[:user_id])
    rescue JWT::DecodeError => e
      render json: { message: e.message }, status: :unauthorized
    end
  end

  def validate_email_confirmation
    return if @current_user.confirmed_email_at.present?

    render json: { message: I18n.t('errors/messages.email_not_confirmed') },
           status: :unauthorized
  end

  def set_paper_trail_whodunnit
    PaperTrail.request.whodunnit = @current_user.id
  end

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :render_conflict
  rescue_from ActiveRecord::RecordNotSaved, with: :render_unprocessable_entity
  rescue_from ActiveRecord::StatementInvalid, with: :render_unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :render_unprocessable_entity
  rescue_from ActionController::UnpermittedParameters, with: :render_unprocessable_entity
  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from ActionController::UnknownFormat, with: :render_not_found
  rescue_from CustomException, with: :render_bad_request

  def render_bad_request(exception)
    render json: { message: exception.message }, status: :bad_request
  end

  def render_unprocessable_entity(exception)
    if [ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved].include?(exception.class)
      return render json: {
        message: exception.message,
        errors: exception.record.errors.messages.presence
      }, status: :unprocessable_entity
    end

    render json: { message: exception.message }, status: :unprocessable_entity
  end

  def render_not_found(exception)
    render json: { message: exception.message }, status: :not_found
  end

  def render_conflict(exception)
    render json: { message: exception.message }, status: :conflict
  end
end
