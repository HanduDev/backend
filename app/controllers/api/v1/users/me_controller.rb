# frozen_string_literal: true

class Api::V1::Users::MeController < ApplicationController
  skip_before_action :validate_email_confirmation

  def show; end
end
