# frozen_string_literal: true

FactoryBot.define do
  factory :trail do
    name { Faker::Lorem.sentence(word_count: 3) }
    started_at { Time.zone.today }
    language { 'en' }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    association :user, factory: :user
    themes { 'theme1, theme2' }
    level { 'beginner' }
    developments { 'development1, development2' }
    time_to_learn { '1 hour' }
    time_to_study { '2 hours' }
  end
end
