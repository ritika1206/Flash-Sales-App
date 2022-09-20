class UserMailer < ApplicationMailer
  def verify_email(user)
    @user = user
    mail to: user.email, subject: 'Email Verifiaction'
  end
end
