# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/users/me', type: :request, swagger_doc: 'api/swagger.yaml' do
  let(:user) { create(:user) }

  path '/api/v1/users/me' do
    put 'Updates user information' do
      tags 'v1 API'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]
      parameter name: 'Authorization', in: :header, type: :string
      parameter name: 'user_params', in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          name: { type: :string }
        }
      }

      let(:access_token) { JwtService.encode(user_id: user.id) }
      let(:Authorization) { "Bearer #{access_token}" }

      response '200', 'User information updated successfully' do
        let(:user_params) { { user: { email: 'new_email@example.com', full_name: 'New Name' } } }

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
        let(:user_params) { { } }

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'Unprocessable entity' do
        let(:user_params) { { user: { email: 'invalid_email' } } }

        run_test!
      end
    end
  end
end
