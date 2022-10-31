class User < ApplicationRecord
  NAME_REGEX = /\A[A-Z]+\z/i
  EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i
  PASSWORD_LENGTH_RANGE = 6..20
  MIN_NAME_LENGTH = 3

  attr_accessor :password_changing

  has_secure_password
  has_secure_token :verification_token
  has_secure_token :api_token

  has_many :deals, foreign_key: 'created_by', dependent: :nullify
  has_many :orders, dependent: :destroy
  has_many :order_transactions, through: :orders
  has_many :addresses, dependent: :destroy
  has_many :line_items, through: :orders

  validates :name, :email, presence: true
  with_options allow_blank: true do |user|
    user.validates :password, confirmation: true
    user.validates :password, length: { in: PASSWORD_LENGTH_RANGE }
    user.validates :email, format: { with: EMAIL_REGEX, message: 'invalid format' }, uniqueness: { case_sensitive: false }
    user.validates :name, format: { with: NAME_REGEX, message: 'can only contain alphabets' }, length: { minimum: MIN_NAME_LENGTH }
  end
  validates :password, presence: true, if: :setting_password?

  after_create_commit :send_verification_email, unless: :verified_at?

  enum role: { user: 'user', admin: 'admin' }

  scope :customer_expenditure, -> (from, to) { joins(:orders).where('orders.placed_at' => from..to).order(sum_orders_discount_price: :desc).select('users.id', :email, :discount_price).group(:email, 'users.id').sum('orders.discount_price') }

  private
    def send_verification_email
      UserMailer.verify_email(self).deliver_later if user?
    end

    def setting_password?
      password_digest_changed? || password_changing.present?
    end
end
