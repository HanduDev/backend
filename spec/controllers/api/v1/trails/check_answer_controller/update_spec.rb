# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::Trails::CheckAnswerController, :unit, type: :controller do
  render_views

  subject(:send_request) { patch :update, params: { check_answer: params, id: id }, format: :json }

  let(:trail) { create(:trail) }
  let!(:lesson) { create(:lesson, trail: trail, activity_type: 'translation', expected_answer: 'correct_answer') }
  let(:id) { lesson.id }

  let(:params) { }

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
      let(:id) { 0 }
      let(:params) { { answer: 'correct_answer' } }

      it { is_expected.to have_http_status(:not_found) }
    end

    context 'when answer is correct' do
      let(:id) { lesson.id }
      let(:params) { { answer: 'correct_answer' } }

      it { is_expected.to have_http_status(:ok) }

      it 'retorna que a resposta está correta' do
        send_request

        expect(json_response).to eq({ correct: true })
      end

      it 'marks the lesson as completed' do
        expect { send_request }.to change { lesson.reload.has_finished }.from(false).to(true)
      end

      it 'defines the lesson completion date' do
        expect { send_request }.to change { lesson.reload.finished_at }.from(nil)
      end
    end

    context 'when answer is incorrect' do
      it { is_expected.to have_http_status(:ok) }
      let(:params) { { answer: 'incorrect_answer' } }

      it 'returns that the answer is incorrect' do
        send_request

        expect(json_response).to eq({ correct: false })
      end

      it 'does not mark the lesson as completed' do
        expect { send_request }.not_to change { lesson.reload.has_finished }
      end

      it 'does not define the lesson completion date' do
        expect { send_request }.not_to change { lesson.reload.finished_at }
      end
    end
  end
end
