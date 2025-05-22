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
class Lesson < ApplicationRecord
  PRACTICAL_ACTIVITY_TYPES = %w[multiple_choice translation].freeze
  POSSIBLE_ACTIVITY_TYPES = %w[theorical].concat(PRACTICAL_ACTIVITY_TYPES).freeze

  MAX_ATTEMPTS = 3

  belongs_to :trail
  has_one :user, through: :trail

  validates :name, presence: true
  validates :has_finished, inclusion: { in: [true, false] }
  validates :finished_at, presence: true, if: :has_finished?
  has_many :options, dependent: :destroy

  before_validation :set_finished_at, if: :has_finished?

  enum :activity_type, POSSIBLE_ACTIVITY_TYPES.index_by(&:itself)

  def check_answer(answer)
    self.user_answer = answer

    if activity_type == 'multiple_choice'
      option = options.find(answer)
      is_correct = option.correct
    elsif activity_type == 'translation'
      prompt = Lesson::TranslationCorrectorPrompt.new(lesson: self).prompt
      response = GoogleAiService.new(user: user).generate_text(prompt: prompt)
      is_correct = response.strip.include?('true')
    else
      is_correct = answer.parameterize == expected_answer&.parameterize
    end

    self.attempt_count += 1
    self.is_correct = is_correct

    self.has_finished = is_correct || attempt_count == MAX_ATTEMPTS

    self.save!

    is_correct
  end

  def is_practical?
    PRACTICAL_ACTIVITY_TYPES.include?(activity_type)
  end

  private

  def set_finished_at
    self.finished_at = Time.current if has_finished?
  end
end
