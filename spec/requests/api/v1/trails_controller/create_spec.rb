# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/trails', type: :request, swagger_doc: 'api/swagger.yaml' do
  let(:user) { create(:user) }

  before do
    ai_trail_response = {
      name: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph
    }.to_json

    ai_lessons_response = [
      {
        name: Faker::Lorem.sentence,
        markdown_content: Faker::Lorem.paragraph
      },
      {
        name: Faker::Lorem.sentence,
        markdown_content: Faker::Lorem.paragraph
      }
    ].to_json

    allow_any_instance_of(GoogleAiService).to receive(:generate_text)
      .and_return(ai_trail_response, ai_lessons_response)
  end

  path '/api/v1/trails' do
    post 'Creates a trail' do
      tags 'Trails'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :trail_params, in: :body, schema: {
        type: :object,
        properties: {
          trail: {
            type: :object,
            properties: {
              language: { type: :string, example: 'en', enum: Language::POSSIBLE_LANGUAGES }
            },
            required: %w[language]
          }
        },
        required: %w[trail]
      }

      let(:access_token) { JwtService.encode(user_id: user.id) }
      let(:Authorization) { "Bearer #{access_token}" }

      response '201', 'Created successfully' do
        let(:trail_params) do
          {
            language: 'pt',
            developments: [Faker::Lorem.sentence],
            level: 'beginner',
            time_to_learn: Faker::Number.between(from: 1, to: 10).to_s,
            time_to_study: Faker::Number.between(from: 1, to: 10).to_s,
            themes: [Faker::Lorem.sentence]
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
        let(:Authorization) { nil }
        let(:trail_params) {}

        after do |example|
          example.metadata[:response][:content] = {
            'application/json': {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response '422', 'Invalid body' do
        let(:trail_params) do
          {
            language: 'any_language',
            developments: '',
            level: '',
            time_to_learn: '',
            time_to_study: '',
            themes: ''
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
    end
  end
end
