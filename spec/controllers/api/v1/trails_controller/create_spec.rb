# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::TrailsController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: { trail: params }, format: :json }

  let(:params) do
    {
      language: 'pt',
      developments: [Faker::Lorem.sentence],
      level: 'beginner',
      time_to_learn: Faker::Number.between(from: 1, to: 10).to_s,
      time_to_study: Faker::Number.between(from: 1, to: 10).to_s,
      themes: [Faker::Lorem.sentence]
    }
  end

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

  it { expect(described_class).to be < ApplicationController }

  context 'when user is not authenticated' do
    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when user is authenticated' do
    let(:user) { create(:user) }

    before do
      authenticate_user(user)
    end

    context 'when language is invalid' do
      let(:params) do
        {
          language: 'any_language',
          developments: '',
          level: '',
          time_to_learn: '',
          time_to_study: '',
          themes: ''
        }
      end

      it { is_expected.to have_http_status(:unprocessable_entity) }

      it 'returns error message' do
        send_request

        expect(json_response).to include(:message, :errors)
      end

      it 'does not create a trail' do
        expect { send_request }.not_to(change { Trail.count })
      end

      it 'does not call AiService generate_text' do
        expect_any_instance_of(GoogleAiService).not_to receive(:generate_text)

        send_request
      end
    end

    context 'when data is invalid' do
      let(:params) do
        {
          language: 'pt',
          developments: '',
          level: '',
          time_to_learn: '',
          time_to_study: '',
          themes: ''
        }
      end

      it { is_expected.to have_http_status(:unprocessable_entity) }

      it 'returns error message' do
        send_request

        expect(json_response).to include(:message, :errors)
      end

      it 'does not create a trail' do
        expect { send_request }.not_to(change { Trail.count })
      end

      it 'does not call AiService generate_text' do
        expect_any_instance_of(GoogleAiService).not_to receive(:generate_text)

        send_request
      end
    end

    context 'when ia_response is invalid' do
      let(:params) do
        {
          language: 'pt',
          developments: [Faker::Lorem.sentence],
          level: 'beginner',
          time_to_learn: Faker::Number.between(from: 1, to: 10).to_s,
          time_to_study: Faker::Number.between(from: 1, to: 10).to_s,
          themes: [Faker::Lorem.sentence]
        }
      end

      before do
        allow_any_instance_of(GoogleAiService).to receive(:generate_text).and_return('text')
      end

      let(:expected_response) do
        {
          message: 'Resposta inválida do assistente.'
        }
      end

      it { is_expected.to have_http_status(:internal_server_error) }

      it 'returns error message' do
        send_request

        expect(json_response).to eq(expected_response)
      end

      it 'does not create a trail' do
        expect { send_request }.not_to(change { Trail.count })
      end
    end
  end
end
