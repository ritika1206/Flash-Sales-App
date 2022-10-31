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
  belongs_to :creator, class_name: "User", foreign_key: 'created_by', optional: true

  validates :title, :description, :price_in_cents, :discount_price_in_cents, :initial_quantity, :tax_percentage, :images, presence: true
  with_options allow_blank: true do |deal|
    deal.validates :description, format: { with: DESCRIPTION_REGEX, message: 'can contain maximum 200 words' }
    deal.validates :title, format: { with: TITLE_REGEX, message: 'can contain maximum 15 words' }, uniqueness: { case_sensitive: false }
    deal.validates :tax_percentage, numericality: { in: TAX_PERCENTAGE_RANGE }
    deal.validates :price_in_cents, numericality: { greater_than_or_equal_to: 0, message: 'should be a positive value' }
    deal.validates :discount_price_in_cents, numericality: { greater_than_or_equal_to: 0, message: 'should be a positive value' }
    deal.validates :current_quantity, numericality: { less_than_or_equal_to: :initial_quantity }
    deal.validates :initial_quantity, numericality: { greater_than_or_equal_to: MIN_INITIAL_QUANTITY }, on: :create
  end
  validates :discount_price_in_cents, numericality: { less_than_or_equal_to: :price_in_cents }, if: [:price_in_cents?, :discount_price_in_cents?, ->(deal) { deal.price_in_cents > 0.1 }]
  validates :published_at, comparison: { greater_than_or_equal_to: Date.today}, on: :create

  before_validation :initialize_current_quantity, if: :new_record?
  after_validation :set_images, on: :create
  before_update :restrict_status_or_publish_date_updation, if: :status_or_published_date_changed_when_less_than_a_day_away_from_publish?
  before_update :set_current_quantity
  after_commit :publishable?, unless: :is_publishable
  
  enum status: { live: 'live', unpublished: 'unpublished', published: 'published', deleted: 'deleted'}

  scope :publish_date_as, ->(date) { where(published_at: date, status: 'unpublished') }
  scope :live, -> { where(status: 'live') }
  scope :publishing_today, -> { Deal.where(published_at: Date.today, status: 'unpublished') }
  scope :published, -> { where(status: 'published') }
  scope :revenue, -> { published.select(:id, :title, '(initial_quantity - current_quantity) * discount_price_in_cents AS revenue').order(revenue: :desc) }

  def publishable?
    images.size >= PUBLISHABLE_DEAL_IMAGE_QUANTITY && initial_quantity > PUBLISHABLE_DEAL_QUANTITY && Deal.publish_date_as(published_at).size <= DEAL_WITH_SAME_PUBLISH_DATE_QUANTITY && !published? && !deleted?
  end

  def less_than_one_day_away_from_publish?
    (published_at - Date.today).to_i <= DATE_DIFFERENCE && (published_at - Date.today).to_i >= 0
  end

  def restrict_status_or_publish_date_updation
    throw :abort
  end

  def status_or_published_date_changed_when_less_than_a_day_away_from_publish?
    less_than_one_day_away_from_publish? && (status_change.try(:last) == 'deleted' || published_at_changed?)
  end

  def set_current_quantity
    self.current_quantity += self.initial_quantity - initial_quantity_was
  end

  def initialize_current_quantity
    self.current_quantity = initial_quantity
  end
end
