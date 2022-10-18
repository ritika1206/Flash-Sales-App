class User < ApplicationRecord
  NAME_REGEX = /\A[A-Z]+\z/i
  EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i
  MIN_PASSWORD_LENGTH = 6
  MIN_NAME_LENGTH = 3

  has_secure_password
  has_secure_token :verification_token
  has_secure_token :api_token

  has_many :deals, foreign_key: 'created_by', dependent: :nullify
  has_many :orders, dependent: :destroy
  has_many :order_transactions, through: :orders
  has_many :addresses, dependent: :destroy
  has_many :line_items, through: :orders

  validates :name, :email, presence: true
  validates :password, confirmation: true
  validates :password, length: { minimum: MIN_PASSWORD_LENGTH }, allow_blank: true
  validates :password, :password_confirmation, presence: true, if: :setting_password?
  validates :email, format: { with: EMAIL_REGEX, message: 'invalid format' }, uniqueness: { case_sensitive: false }, allow_blank: true
  validates :name, format: { with: NAME_REGEX, message: 'can only contain alphabets' }, length: { minimum: MIN_NAME_LENGTH }, allow_blank: true

  after_create_commit :send_verification_email, unless: :verified_at?

  scope :customer_expenditure, -> (from, to) { User.joins(:orders).where('orders.placed_at' => from..to).order(sum_orders_discount_price: :desc).select('users.id', :email, :discount_price).group(:email, 'users.id').sum('orders.discount_price') }

  enum role: { user: 'user', admin: 'admin' }

  private
    def send_verification_email
      UserMailer.verify_email(self).deliver_now if user?
    end

    def setting_password?
      password_digest_changed?
    end
end
