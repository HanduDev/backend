# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def email_confirm(user)
    @user = user

    mail(to: @user.email, subject: I18n.t('modules/users/email_confirm_mailer.confirm_email.subject'))
  end
end
