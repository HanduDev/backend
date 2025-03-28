# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::V1::Users::ConfirmEmailController, :unit, type: :controller do
  render_views

  subject(:send_request) { post :create, params: params, format: :json }

  let!(:user) do
    create(:user, confirm_email_code: confirm_email_code,
                  confirm_email_code_sent_at: confirm_email_code_sent_at,
                  password: 'Password_001',
                  confirmed_email_at: confirmed_email_at)
  end

  let(:confirmed_email_at) { nil }
  let(:confirm_email_code) { '1234' }
  let(:confirm_email_code_sent_at) { Time.current }
  let(:params) do
    { user: { code: '1234' } }
  end

  it { expect(described_class).to be < ApplicationController }

  context 'when user is not authenticated' do
    it { expect(send_request).to have_http_status(:unauthorized) }
  end

  context 'when user is authenticated' do
    before do
      authenticate_user(user)
    end

    context 'when confirmation code is valid' do
      it { expect(send_request).to have_http_status(:ok) }

      it do
        send_request

        expect(user.reload.confirmed_email_at).to be_present
      end
    end

    context 'when confirmation code is expired' do
      let(:confirm_email_code_sent_at) { 5.days.ago }

      it { expect(send_request).to have_http_status(:unprocessable_entity) }

      it do
        send_request

        expect(user.reload.confirmed_email_at).to be_blank
      end
    end

    context 'when confirmation code is invalid' do
      let(:confirm_email_code) { 'invalid_code' }
      let(:confirm_email_code_sent_at) { Time.current }

      it { expect(send_request).to have_http_status(:unprocessable_entity) }

      it do
        send_request

        expect(user.reload.confirmed_email_at).to be_blank
      end
    end

    context 'when confirmation code is already confirmed' do
      let(:user) { create(:user, confirmed_email_at: Time.current) }

      it { expect(send_request).to have_http_status(:conflict) }

      it do
        send_request

        expect(user.reload.confirmed_email_at).to be_present
      end
    end
  end
end
