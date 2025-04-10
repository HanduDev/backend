# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::TrailsController, :unit, type: :controller do
  render_views

  subject(:send_request) { get :show, params: { id: id }, format: :json }
  let(:id) { 0 }

  it { expect(described_class).to be < ApplicationController }

  context 'when user is not authenticated' do
    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when user is authenticated' do
    let(:user) { create(:user) }

    before do
      authenticate_user(user)
    end

    context 'when trails is not found' do
      let!(:trail) { create(:trail) }
      let(:id) { trail.id }

      it { is_expected.to have_http_status(:not_found) }

      it 'should return error message' do
        send_request

        expect(json_response).to eq({ message: 'Trilha não encontrada' })
      end
    end

    context 'when trail is found' do
      before { create_list(:lesson, 2, trail: trail) }

      let!(:trail) { create(:trail, user: user, language: 'pt') }
      let(:id) { trail.id }

      let(:expected_response) do
        {
          trail: {
            id: trail.id,
            name: trail.name,
            description: trail.description,
            language: {
              name: 'Português',
              code: trail.language
            },
            progress: trail.progress,
            lessons: trail.lessons.map do |lesson|
              {
                id: lesson.id,
                name: lesson.name
              }
            end
          }
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
