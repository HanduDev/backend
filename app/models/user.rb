# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  full_name       :string           not null
#  email           :string           not null
#  password_digest :string
#  google_id       :string
#  photo_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  has_secure_password

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: -> { google_id.blank? }

  validate :validate_password_strength

  before_validation :downcase_email, if: -> { email.present? }
  before_save :validate_existance, if: -> { email_changed? }
  before_save :validate_password_strength, if: -> { self.password_digest_changed? }

  has_many :ai_responses, dependent: :destroy

  private

  def validate_password_strength
    return if password.blank? || password.match?(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/)

    errors.add(:password, I18n.t('modules/users/errors/messages.invalid_password'))
  end

  def validate_existance
    existing_user = User.find_by(email: self.email)

    return if existing_user.blank?

    existing_user.errors.add(field, I18n.t('modules/users/errors/messages.email_taken'))
  end

  def downcase_email
    self.email = self.email.downcase
  end
end
