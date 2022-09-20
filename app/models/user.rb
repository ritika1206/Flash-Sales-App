class User < ApplicationRecord
  has_secure_password
  has_secure_token :verification_token
  
  attr_accessor :password_digest

  validates :name, :email, presence: true
  validates :email, format: { with: EMAIL_REGEX }
end
