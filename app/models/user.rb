# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  full_name                  :string           not null
#  email                      :string           not null
#  password_digest            :string
#  google_id                  :string
#  photo_url                  :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  confirm_email_code         :string
#  confirm_email_code_sent_at :datetime
#  confirmed_email_at         :datetime
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  has_secure_password

  has_one_attached :photo

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true, if: -> { google_id.blank? }

  validate :validate_password_strength

  before_validation :downcase_email, if: -> { email.present? }
  before_save :validate_existance, if: -> { email_changed? }
  before_save :validate_password_strength, if: -> { self.password_digest_changed? }

  has_many :ai_responses, dependent: :destroy
  has_many :trails, dependent: :destroy
  has_many :lessons, through: :trails

  def email_confirmed?
    confirmed_email_at.present?
  end

  def email_confirmation_code_valid?(code:)
    confirm_email_code.present? &&
      confirm_email_code_sent_at.present? &&
      confirm_email_code_sent_at > 1.hour.ago &&
      confirm_email_code == code
  end

  def send_email_confirmation
    self.confirm_email_code = SecureRandom.alphanumeric(4).upcase
    self.confirm_email_code_sent_at = Time.current
    save!
    UserMailer.email_confirm(self).deliver_later
  end


  def picture_url
    return photo_url if photo_url.present?

    return Rails.application.routes.url_helpers.service_url(photo, only_path: true) if photo.attached?

    nil
  end

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
