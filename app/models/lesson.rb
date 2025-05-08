# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id               :integer          not null, primary key
#  activity_type    :string
#  expected_answer  :string
#  finished_at      :datetime
#  has_finished     :boolean          default(FALSE), not null
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
class Lesson < ApplicationRecord
  belongs_to :trail

  validates :name, presence: true
  validates :has_finished, inclusion: { in: [true, false] }
  validates :finished_at, presence: true, if: :has_finished?

  has_many :options, dependent: :destroy

  before_validation :set_finished_at, if: :has_finished?

  def check_answer(answer)
    self.user_answer = answer

    if activity_type == 'multiple_choice'
      option = options.find(answer)
      option.correct
    else
      answer.parameterize == expected_answer&.parameterize
    end

  end

  private

  def set_finished_at
    self.finished_at = Time.current if has_finished?
  end
end
