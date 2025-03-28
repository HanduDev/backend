# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'Password_001' }
    full_name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@email.com" }
    confirm_email_code { '1234' }
    confirm_email_code_sent_at { Time.current }
    confirmed_email_at { Time.current }
  end
end
