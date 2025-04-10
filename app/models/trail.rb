# frozen_string_literal: true

# == Schema Information
#
# Table name: trails
#
#  id          :integer          not null, primary key
#  description :text             not null
#  language    :string           not null
#  name        :string           not null
#  started_at  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
# Indexes
#
#  index_trails_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#

class Trail < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :language, presence: true
  validates :description, presence: true

  validates :language, inclusion: { in: Language::POSSIBLE_LANGUAGES }

  def lang
    Language.new(acronym: self.language)
  end

  def progress
    return 0 if lessons.empty?

    finished_lessons = lessons.select(&:has_finished?)
    total_lessons = lessons.count

    (finished_lessons.count.to_f / total_lessons * 100).round(2)
  end
end
