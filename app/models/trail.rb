# frozen_string_literal: true

# == Schema Information
#
# Table name: trails
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  started_at  :date
#  language    :string           not null
#  description :text             not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_trails_on_user_id  (user_id)
#

class Trail < ApplicationRecord
  belongs_to :user, optional: true

  validates :name, presence: true
  validates :language, presence: true
  validates :description, presence: true

  validates :language, inclusion: { in: Language::POSSIBLE_LANGUAGES }
end
