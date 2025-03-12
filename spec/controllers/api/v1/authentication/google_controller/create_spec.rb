# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::Authentication::GoogleController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: { user: { token: Faker::Internet.password } }, format: :json }

  it { expect(described_class).to be < ApplicationController }

  describe 'POST #create' do
    before do
      allow(GoogleAuthService).to receive(:authenticate).and_return(google_auth_data)
    end

    let(:google_auth_data) do
      {
        'email' => Faker::Internet.email,
        'sub' => Faker::Internet.password,
        'given_name' => Faker::Name.first_name,
        'family_name' => Faker::Name.last_name,
        'picture' => Faker::Internet.url
      }
    end

    let(:email) { google_auth_data['email'] }
    let(:google_id) { google_auth_data['sub'] }

    context 'when the user exists' do
      context 'when the user google_id is the same' do
        let!(:user) { create(:user, google_id: google_id) }

        it 'does NOT create a new user' do
          expect { send_request }.not_to change(User, :count)
        end

        it { is_expected.to have_http_status(:ok) }

        it 'returns a token' do
          send_request

          expect(JSON.parse(response.body, symbolize_names: true)).to include(:token)
        end
      end

      context 'when the user email is the same' do
        let!(:user) { create(:user, email: email) }

        it 'does NOT create a new user' do
          expect { send_request }.not_to change(User, :count)
        end

        it { is_expected.to have_http_status(:ok) }

        it 'returns a token' do
          send_request

          expect(JSON.parse(response.body, symbolize_names: true)).to include(:token)
        end
      end
    end

    context 'when user does not exists' do
      it 'creates a new user' do
        expect { send_request }.to change(User, :count).by(1)
      end

      it 'creates a new user with the correct attributes' do
        send_request

        user = User.last

        expect(user.email).to eq(google_auth_data['email'])
        expect(user.google_id).to eq(google_auth_data['sub'])
        expect(user.photo_url).to eq(google_auth_data['picture'])
        expect(user.full_name).to eq("#{google_auth_data['given_name']} #{google_auth_data['family_name']}")
      end

      it { is_expected.to have_http_status(:created) }

      it 'returns a token' do
        send_request

        expect(JSON.parse(response.body, symbolize_names: true)).to include(:token)
      end
    end
  end
end
