# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::Authentication::RegisterController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: { user: params }, format: :json }

  it { expect(described_class).to be < ApplicationController }

  before do
    allow(UserMailer).to receive(:email_confirm).and_return(double(deliver_later: nil))
  end

  describe 'POST #create' do
    context 'when the user exists' do
      let!(:user) { create(:user) }

      let(:params) do
        {
          password: user.password,
          full_name: user.full_name,
          email: user.email
        }
      end

      it 'returns an error' do
        send_request

        expect(response).to have_http_status(:conflict)
        expect(JSON.parse(response.body, symbolize_names: true)).to include(:message)
      end
    end

    context 'when create user' do
      context 'with valid password' do
        let(:user) { build(:user) }

        let(:params) do
          {
            password: user.password,
            full_name: user.full_name,
            email: user.email
          }
        end

        it 'should create user' do
          send_request

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body, symbolize_names: true)).to include(:token)
        end

        it 'sends email confirmation' do
          send_request

          expect(UserMailer).to have_received(:email_confirm)
        end
      end

      context 'with invalid password' do
        let(:params) do
          { user: { email: Faker::Internet.email, full_name: Faker::Name.name, password: 'weak_password' } }
        end

        it 'should return an error' do
          send_request

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body, symbolize_names: true)).to include(:errors)
          expect(JSON.parse(response.body, symbolize_names: true)).to include(:message)
        end
      end
    end
  end
end
