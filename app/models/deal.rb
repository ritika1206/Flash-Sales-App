class Deal < ApplicationRecord
  DESCRIPTION_REGEX = /\A(?:\b\w+\b[\s\r\n.,'"?!]*){1,200}\z/
  TITLE_REGEX = /\A(?:\b\w+\b[\s\r\n.,'"?!]*){1,15}\z/
  MIN_INITIAL_QUANTITY = 10
  TAX_PERCENTAGE_RANGE = 0..28

  PUBLISHABLE_DEAL_IMAGE_QUANTITY = 2
  PUBLISHABLE_DEAL_QUANTITY = 10
  DEAL_WITH_SAME_PUBLISH_DATE_QUANTITY = 2
  DATE_DIFFERENCE = 1
  
  has_many_attached :images
  has_many :line_items, dependent: :destroy
  has_many :orders, through: :line_items, dependent: :destroy
  belongs_to :created_by, class_name: "User", foreign_key: 'created_by'

  before_update :restrict, if: ->(deal) { deal.less_than_one_day_away_from_publish? && (deal.status_change.try(:last) == 'deleted' || deal.published_at_changed?) }
  before_update :set_current_quantity
  after_destroy { |deal| deal.images.purge }
  after_commit :publishable?, unless: ->{ is_publishable }

  validates :title, :description, :price_in_cents, :discount_price_in_cents, :initial_quantity, :tax_percentage, presence: true
  validates :description, format: { with: DESCRIPTION_REGEX, message: 'can contain maximum 200 words' }, allow_blank: true
  validates :title, format: { with: TITLE_REGEX, message: 'can contain maximum 15 words' }, uniqueness: { case_sensitive: false }, allow_blank: true
  validates :tax_percentage, numericality: { in: TAX_PERCENTAGE_RANGE }, allow_blank: true
  validates :price_in_cents, numericality: { greater_than_or_equal_to: 0, message: 'should be a positive value' }, allow_blank: true
  validates :discount_price_in_cents, numericality: { less_than_or_equal_to: :price_in_cents }, if: [:price_in_cents?, :discount_price_in_cents?, ->(deal) { deal.price_in_cents > 0.1 }]
  validates :discount_price_in_cents, numericality: { greater_than_or_equal_to: 0, message: 'should be a positive value' }, allow_blank: true
  validates :initial_quantity, numericality: { greater_than_or_equal_to: MIN_INITIAL_QUANTITY }, allow_blank: true, on: :create
  validates :current_quantity, numericality: { less_than_or_equal_to: :initial_quantity }, allow_blank: true
  validates :published_at, comparison: { greater_than_or_equal_to: Date.today}, on: :create

  scope :number_of_deals_with_publish_date, ->(date) { where(published_at: date).size }
  scope :live_deals, -> { where(status: 'live') }
  scope :deals_publishing_today, -> { Deal.where(published_at: Date.today) }
  scope :published_deals, -> { where(status: 'published') }
  scope :deals_revenue, -> { published_deals.select(:id, :title, '(initial_quantity - current_quantity) * discount_price_in_cents / 100 AS revenue').order(revenue: :desc) }

  enum status: { live: 'live', unpublished: 'unpublished', published: 'published', deleted: 'deleted'}

  def publishable?
    return true if images.size >= PUBLISHABLE_DEAL_IMAGE_QUANTITY && initial_quantity > PUBLISHABLE_DEAL_QUANTITY && Deal.number_of_deals_with_publish_date(published_at) <= DEAL_WITH_SAME_PUBLISH_DATE_QUANTITY && !published? && !deleted?

  end

  def less_than_one_day_away_from_publish?
    (published_at - Date.today).to_i <= DATE_DIFFERENCE && (published_at - Date.today).to_i >= 0
  end

  def restrict
    throw :abort
  end

  def set_current_quantity
    self.current_quantity += self.initial_quantity - initial_quantity_was
  end
end
