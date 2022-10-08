class User < ApplicationRecord
  has_secure_password
  has_secure_token :verification_token
  has_many :deals, foreign_key: 'created_by'
  has_many :orders, dependent: :destroy
  has_many :order_transaction, through: :orders
  has_many :addresses, dependent: :destroy

  validates :name, :email, presence: true
  validates :password, confirmation: true, allow_blank: true
  validates :password, :password_confirmation, presence: true, if: :setting_password?
  validates :email, format: { with: FlashSales::User::EMAIL_REGEX }, uniqueness: true

  after_create_commit :send_verification_email, unless: :verified_at?

  enum role: { user: 'user', admin: 'admin' }

  private
    def send_verification_email
      UserMailer.verify_email(self).deliver_now if user?
    end

    def setting_password?
      password || password_confirmation
    end

    # def loyality_discount_percentage
    #   order_number = Order.count(email: email)
    #   case
    #   when order_number >= 6
    #     loyality_discount_percentage = 5
    #   when order_number = 5
    #     loyality_discount_percentage = 4
    #   when order_number = 4
    #     loyality_discount_percentage = 3
    #   when order_number = 3
    #     loyality_discount_percentage = 2
    #   when order_number = 2
    #     loyality_discount_percentage = 1
    #   end
    # end
end
