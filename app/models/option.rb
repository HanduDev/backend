# == Schema Information
#
# Table name: options
#
#  id         :integer          not null, primary key
#  content    :string           not null
#  correct    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lesson_id  :integer          not null
#
# Indexes
#
#  index_options_on_lesson_id  (lesson_id)
#
# Foreign Keys
#
#  lesson_id  (lesson_id => lessons.id)
#
class Option < ApplicationRecord
  belongs_to :lesson
end
