class User < ApplicationRecord
  has_secure_password validations: false
  has_secure_token :verification_token
  
  attr_accessor :password_digest

  validates :name, :email, presence: true
  validates :password, confirmation: true, allow_blank: true
  validates :password, :password_confirmation, presence: true, if: :setting_password?
  validates :email, format: { with: EMAIL_REGEX }

  after_create_commit :send_verification_email

  private
    def send_verification_email
      UserMailer.verify_email(self).deliver_now
    end

    def setting_password?
      password || password_confirmation
    end
end
