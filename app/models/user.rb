class User < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, format: { with: EMAIL_REGEX }
end
