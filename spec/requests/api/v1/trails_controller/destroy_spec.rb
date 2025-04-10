# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/trails', type: :request, swagger_doc: 'api/swagger.yaml' do
  let(:user) { create(:user) }
  let!(:trail) { create(:trail, user: user) }

  path '/api/v1/trails/{id}' do
    delete 'Deletes a trails' do
      tags 'Trails'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string
      parameter name: 'id', in: :path, type: :integer, required: true, description: 'ID of the trail to delete'

      let(:access_token) { JwtService.encode(user_id: user.id) }
      let(:Authorization) { "Bearer #{access_token}" }
      let(:id) { trail.id }

      response '204', 'Deleted successfully' do
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

      response '404', 'Trail not found' do
        let(:id) { 0 }

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
