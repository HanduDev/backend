# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/lessons', type: :request, swagger_doc: 'api/swagger.yaml' do
  let(:user) { create(:user) }

  before { create_list(:lesson, 3, trail: create(:trail, user: user)) }

  path '/api/v1/lessons' do
    get 'Returns a list of lessons' do
      tags 'Lessons'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string

      let(:access_token) { JwtService.encode(user_id: user.id) }
      let(:Authorization) { "Bearer #{access_token}" }

      response '200', 'Returned successfully' do
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
    end
  end
end
