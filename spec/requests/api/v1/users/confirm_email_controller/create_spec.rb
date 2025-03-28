# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/users/confirm_email', type: :request, swagger_doc: 'api/swagger.yaml' do
  let(:user) { create(:user, confirm_email_code: '1234', confirm_email_code_sent_at: Time.current, confirmed_email_at: confirmed_email_at) }
  let(:confirmed_email_at) { nil }

  before do
    allow_any_instance_of(GoogleAiService).to receive(:generate_text).and_return('Olá, mundo!')
  end

  path '/api/v1/users/confirm_email' do
    post 'Confirm email' do
      tags 'Users'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string

      let(:access_token) { JwtService.encode(user_id: user.id) }
      let(:Authorization) { "Bearer #{access_token}" }

      parameter name: :confirm_email_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              code: { type: :string, example: '1234' }
            },
            required: %w[code]
          }
        },
        required: %w[user]
      }

      response '200', 'Email confirmed successfully' do
        let(:confirm_email_params) do
          {
            user: {
              code: '1234'
            }
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json': {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response '422', 'Invalid confirmation code' do
        let(:confirm_email_params) do
          {
            user: {
              code: 'invalid_code'
            }
          }
        end

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
        let(:confirm_email_params) { {} }
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

      response '422', 'Invalid params' do
        let(:confirm_email_params) { {} }

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
