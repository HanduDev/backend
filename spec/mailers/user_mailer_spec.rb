# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'email_confirm' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.email_confirm(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Confirme seu e-mail')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end
