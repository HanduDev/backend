# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::LessonsController, :unit, type: :controller do
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

    context 'when lesson is not found' do
      let!(:lesson) { create(:lesson) }
      let(:id) { lesson.id }

      it { is_expected.to have_http_status(:not_found) }

      it 'should return error message' do
        send_request

        expect(json_response).to eq({ message: 'Aula não encontrada' })
      end
    end

    context 'when lesson is found' do
      let!(:lesson) { create(:lesson, trail: create(:trail, user: user), name: 'Aula de Teste') }
      let(:id) { lesson.id }

      let(:expected_response) do
        {
          lesson: {
            id: lesson.id,
            name: lesson.name,
            content: lesson.markdown_content,
            hasFinished: lesson.has_finished,
            createdAt: lesson.created_at
          }
        }
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns the lesson' do
        send_request

        expect(json_response.to_json).to eq(expected_response.to_json)
      end
    end
  end
end
