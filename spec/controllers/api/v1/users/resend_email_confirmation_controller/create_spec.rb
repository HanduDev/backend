# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::Users::ResendEmailConfirmationController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, format: :json }

  let!(:user) { create(:user, password: 'Password_001', confirmed_email_at: confirmed_email_at) }
  let(:confirmed_email_at) { nil }

  before do
    allow(UserMailer).to receive(:email_confirm).and_return(double(deliver_later: nil))
  end

  it { expect(described_class).to be < ApplicationController }

  context 'when user is not authenticated' do
    it { expect(send_request).to have_http_status(:unauthorized) }
  end

  context 'when user is authenticated' do
    before do
      authenticate_user(user)
    end

    it 'sends email confirmation' do
      send_request

      expect(UserMailer).to have_received(:email_confirm).with(user)
    end
  end
end
