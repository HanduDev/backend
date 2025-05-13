# frozen_string_literal: true

# == Schema Information
#
# Table name: trails
#
#  id            :integer          not null, primary key
#  description   :text             not null
#  developments  :string           default(""), not null
#  language      :string           not null
#  level         :string           default(""), not null
#  name          :string           not null
#  started_at    :date
#  themes        :string           default(""), not null
#  time_to_learn :string           default(""), not null
#  time_to_study :string           default(""), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
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
  validates :level, presence: true
  validates :themes, presence: true
  validates :time_to_learn, presence: true
  validates :time_to_study, presence: true
  validates :developments, presence: true
  validates :language, inclusion: { in: Language::POSSIBLE_LANGUAGES }

  has_many :lessons, dependent: :destroy

  def lang
    Language.new(acronym: self.language)
  end

  def progress
    return 0 if lessons.empty?

    total_lessons = lessons.count

    (finished_lessons.count.to_f / total_lessons * 100).round(2)
  end

  def finished_lessons
    lessons.where(has_finished: true)
  end
end
