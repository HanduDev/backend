# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::TrailsController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: { trail: { language: language } }, format: :json }
  let(:language) { 'pt' }

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
      let(:language) { 'invalid_language' }

      it { is_expected.to have_http_status(:bad_request) }

      it 'returns error message' do
        send_request

        expect(json_response).to eq({ message: 'Linguagem não está incluído na lista' })
      end

      it 'does not create a trail' do
        expect { send_request }.not_to(change { Trail.count })
      end

      it 'does not call AiService generate_text' do
        expect_any_instance_of(GoogleAiService).not_to receive(:generate_text)

        send_request
      end
    end

    context 'when language is valid' do
      before do
        ai_response = {
          name: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph
        }.to_json

        allow_any_instance_of(GoogleAiService).to receive(:generate_text).and_return(ai_response)
      end

      let(:expected_response) do
        {
          trail: {
            id: trail.id,
            name: trail.name,
            description: trail.description,
            language: {
              name: 'Português',
              code: trail.language
            }
          }
        }
      end

      let(:trail) { Trail.last }

      it { is_expected.to have_http_status(:created) }

      it 'returns the trails' do
        send_request

        trail.reload

        expect(json_response).to eq(expected_response)
      end
    end

    context 'when ia_response is invalid' do
      before do
        allow_any_instance_of(GoogleAiService).to receive(:generate_text).and_return('text')
      end

      let(:expected_response) do
        {
          message: 'Resposta inválida do assistente.'
        }
      end

      it { is_expected.to have_http_status(:bad_request) }

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
