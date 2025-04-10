# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::LessonsController, :unit, type: :controller do
  render_views

  subject(:send_request) { delete :destroy, params: { id: id }, format: :json }
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
      let(:trail) { create(:trail, user: user) }
      let!(:lesson) { create(:lesson, trail: trail) }
      let(:id) { lesson.id }

      it { is_expected.to have_http_status(:no_content) }

      it 'deletes the lesson' do
        expect { send_request }.to change(Lesson, :count).by(-1)
      end
    end
  end
end
