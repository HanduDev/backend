# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id               :integer          not null, primary key
#  finished_at      :datetime
#  has_finished     :boolean          default(FALSE), not null
#  markdown_content :string           not null
#  name             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  trail_id         :integer          not null
#
# Indexes
#
#  index_lessons_on_trail_id  (trail_id)
#
# Foreign Keys
#
#  trail_id  (trail_id => trails.id)
#
FactoryBot.define do
  factory :lesson do
    trail { create(:trail) }
    name { Faker::Lorem.sentence }
    markdown_content { Faker::Lorem.paragraph }
    has_finished { false }
    finished_at { nil }
  end
end
