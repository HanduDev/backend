# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/authentication/login', type: :request, swagger_doc: 'api/swagger.yaml' do
  let(:user) { create(:user) }

  path '/api/v1/authentication/login' do
    post 'Authenticate an user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: Faker::Internet.email },
              password: { type: :string, example: Faker::Internet.password }
            }
          }
        },
        required: %w[email password]
      }

      response '401', 'User or password invalid' do
        let(:user_params) { { user: { email: 'invalid', password: 'invalid' } } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json': {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response '200', 'Informations loaded successfully' do
        let(:user_params) { { user: { email: user.email, password: user.password } } }

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
