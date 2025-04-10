# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::TrailsController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :index, format: :json }

  it { expect(described_class).to be < ApplicationController }

  context 'when user is not authenticated' do
    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when user is authenticated' do
    let(:user) { create(:user) }

    before do
      authenticate_user(user)
    end

    context 'when user has no trails' do
      let!(:trails) { create_list(:trail, 2) }

      let(:expected_response) { { trails: [] } }

      it 'returns an empty array' do
        send_request

        expect(json_response).to eq(expected_response)
      end
    end

    context 'when user has trails' do
      let!(:trails) { create_list(:trail, 2, user: user, language: 'pt') }

      let(:expected_response) do
        {
          trails: trails.map do |trail|
            {
              id: trail.id,
              name: trail.name,
              description: trail.description,
              language: {
                name: 'Português',
                code: trail.language
              }
            }
          end
        }
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns the trails' do
        send_request

        expect(json_response).to eq(expected_response)
      end
    end
  end
end
