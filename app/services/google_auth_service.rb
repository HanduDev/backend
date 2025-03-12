# frozen_string_literal: true

require 'google-id-token'

module GoogleAuthService
  module_function

  def authenticate(token:)
    GoogleIDToken::Validator.new.check(token, ENV.fetch('GOOGLE_CLIENT_ID', nil))
  end
end
