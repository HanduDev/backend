# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::LessonsController, :unit, type: :controller do
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

    context 'when user has no lessons' do
      let!(:lessons) { create_list(:lesson, 2) }

      let(:expected_response) { { lessons: [] } }

      it 'returns an empty array' do
        send_request

        expect(json_response).to eq(expected_response)
      end
    end

    context 'when user has lessons' do
      let(:trail) { create(:trail, user: user) }
      let!(:lessons) { create_list(:lesson, 2, trail: trail) }

      let(:expected_response) do
        {
          lessons: lessons.map do |lesson|
            {
              id: lesson.id,
              name: lesson.name,
              hasFinished: lesson.has_finished,
              activityType: lesson.activity_type,
            }
          end
        }
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns the lessons' do
        send_request

        expect(json_response).to eq(expected_response)
      end
    end
  end
end
