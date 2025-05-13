# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/api/v1/translate_text', type: :request, swagger_doc: 'api/swagger.yaml' do
  let(:user) { create(:user) }

  before do
    allow_any_instance_of(GoogleAiService).to receive(:generate_text).and_return('Olá, mundo!')
  end

  path '/api/v1/translate_text' do
    post 'Translate an text to another language' do
      tags 'Translate Text'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string

      let(:access_token) { JwtService.encode(user_id: user.id) }
      let(:Authorization) { "Bearer #{access_token}" }

      parameter name: :translate_params, in: :body, schema: {
        type: :object,
        properties: {
          translate: {
            type: :object,
            properties: {
              text: { type: :string, example: 'Hello, world!' },
              image: { type: :string, example: 'https://example.com/image.jpg' },
              from_language: { type: :string, example: 'en', enum: Language::POSSIBLE_LANGUAGES },
              to_language: { type: :string, example: 'pt', enum: Language::POSSIBLE_LANGUAGES }
            },
            required: %w[text from_language to_language]
          }
        },
        required: %w[translate]
      }

      response '200', 'Translated successfully' do
        let(:translate_params) do
          {
            translate: {
              text: 'Hello, world!',
              from_language: 'en',
              to_language: 'pt'
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

      response '400', 'Invalid language' do
        let(:translate_params) do
          {
            translate: {
              text: 'Hello, world!',
              from_language: 'en',
              to_language: 'any_language'
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
        let(:translate_params) { {} }
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

      response '422', 'Invalid params' do
        let(:translate_params) { {} }

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
