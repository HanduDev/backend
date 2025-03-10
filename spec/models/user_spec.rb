# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  full_name       :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

require 'spec_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    context 'is valid with valid attributes' do
      let(:user) { create(:user) }

      it do
        expect(user).to be_valid
      end
    end

    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to have_many(:ai_responses) }

    context 'is not valid duplicated user' do
      let(:email) { Faker::Internet.email }
      let!(:user1) { create(:user, email: email) }
      let(:user2) { build(:user, email: email) }

      it { expect(user2).to_not be_valid }
    end

    context 'is not valid with a weak password' do
      let!(:user) { build(:user, password: 'weak_password') }
      let!(:user2) { build(:user, password: 'password_001') }
      let!(:user3) { build(:user, password: 'PASSWORD_001') }
      let!(:user4) { build(:user, password: 'Password001') }

      it do
        user.save
        user2.save
        user3.save
        user4.save

        expect(user.errors).to include(:password)
        expect(user2.errors).to include(:password)
        expect(user3.errors).to include(:password)
        expect(user4.errors).to include(:password)

        expect(user).to_not(be_valid)
        expect(user2).to_not(be_valid)
        expect(user3).to_not(be_valid)
        expect(user4).to_not(be_valid)
      end
    end

    context 'is valid with a strong password' do
      let!(:user) { build(:user, password: 'Password_001') }

      it { expect(user).to be_valid }
    end
  end

  context 'authentication' do
    context 'is valid with valid password' do
      let(:user) { create(:user) }

      it { expect(user.authenticate(user.password)).to eq(user) }
    end

    context 'is not valid with invalid password' do
      let(:user) { create(:user) }

      it { expect(user.authenticate('invalid_password')).to eq(false) }
    end
  end
end
