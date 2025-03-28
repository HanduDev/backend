# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/users/resend_email_confirmation', type: :request, swagger_doc: 'api/swagger.yaml' do
  let(:user) { create(:user, confirm_email_code: '1234', confirm_email_code_sent_at: Time.current, confirmed_email_at: confirmed_email_at) }
  let(:confirmed_email_at) { nil }

  before do
    allow_any_instance_of(GoogleAiService).to receive(:generate_text).and_return('Olá, mundo!')
  end

  path '/api/v1/users/resend_email_confirmation' do
    post 'Resend email confirmation' do
      tags 'Users'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string

      let(:access_token) { JwtService.encode(user_id: user.id) }
      let(:Authorization) { "Bearer #{access_token}" }

      response '200', 'Email confirmation sent' do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json': {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response '401', 'Expired or invalid session' do
        let(:Authorization) { nil }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json': {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response '409', 'Email already confirmed' do
        let(:confirm_email_params) do
          {
            user: { code: '1234' }
          }
        end

        let(:confirmed_email_at) { Time.current }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json': {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
    end
  end
end
