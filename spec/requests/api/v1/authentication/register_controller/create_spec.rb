# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/authentication/register', type: :request, swagger_doc: 'api/swagger.yaml' do
  before do
    allow_any_instance_of(User).to receive(:send_email_confirmation).and_return(true)
  end

  path '/api/v1/authentication/register' do
    post 'Register an user' do
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
              password: { type: :string, example: Faker::Internet.password },
              full_name: { type: :string, example: Faker::Name.name }
            }
          }
        },
        required: %w[email password full_name]
      }

      response '409', 'User already exists' do
        let!(:user) { create(:user) }
        let(:user_params) { { user: { email: user.email, password: user.password, full_name: user.full_name } } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json': {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response '422', 'Invalid password' do
        let(:user_params) do
          { user: { email: Faker::Internet.email, password: 'weak_password', full_name: Faker::Name.name } }
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

      response '201', 'Created successfully' do
        let(:user_params) do
          { user: { email: Faker::Internet.email, password: create(:user).password, full_name: Faker::Name.name } }
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
    end
  end
end
