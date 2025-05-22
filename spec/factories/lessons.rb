# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id               :integer          not null, primary key
#  activity_type    :string
#  attempt_count    :integer          default(0)
#  expected_answer  :string
#  finished_at      :datetime
#  has_finished     :boolean          default(FALSE), not null
#  is_correct       :boolean          default(FALSE)
#  markdown_content :text             default("")
#  name             :string           not null
#  question         :string
#  user_answer      :string
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
