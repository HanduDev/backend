# frozen_string_literal: true

# == Schema Information
#
# Table name: ai_responses
#
#  id            :integer          not null, primary key
#  model         :string           not null
#  output        :text             not null
#  system_prompt :text
#  total_tokens  :integer          not null
#  user_prompt   :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_ai_responses_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#

class AiResponse < ApplicationRecord
  validates :user_prompt, presence: true
  validates :output, presence: true
  validates :total_tokens, presence: true
  validates :model, presence: true

  belongs_to :user
end
