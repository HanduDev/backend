# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/authentication/google', type: :request, swagger_doc: 'api/swagger.yaml' do
  path '/api/v1/authentication/google' do
    post 'Authenticate by google' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :google_user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              token: { type: :string, example: Faker::Internet.password }
            },
            required: %w[token]
          }
        },
        required: %w[user]
      }

      response '200', 'Logged successfully' do
        before do
          user = create(:user)
          allow(GoogleAuthService).to receive(:authenticate).and_return({
                                                                          'email' => user.email,
                                                                          'sub' => user.google_id,
                                                                          'given_name' => Faker::Name.first_name,
                                                                          'family_name' => Faker::Name.last_name,
                                                                          'picture' => Faker::Internet.url
                                                                        })
        end

        let(:google_user_params) do
          { user: { token: Faker::Internet.password } }
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

      response '201', 'Created and logged successfully' do
        before do
          allow(GoogleAuthService).to receive(:authenticate).and_return({
                                                                          'email' => Faker::Internet.email,
                                                                          'sub' => Faker::Internet.password,
                                                                          'given_name' => Faker::Name.first_name,
                                                                          'family_name' => Faker::Name.last_name,
                                                                          'picture' => Faker::Internet.url
                                                                        })
        end

        let(:google_user_params) do
          { user: { token: Faker::Internet.password } }
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

      response '401', 'Unauthorized' do
        before do
          allow(GoogleAuthService).to receive(:authenticate).and_raise(StandardError)
        end

        let(:google_user_params) { { user: { token: Faker::Internet.password } } }

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
