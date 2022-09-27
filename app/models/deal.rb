class Deal < ApplicationRecord
  has_many_attached :images
  belongs_to :admin, class_name: "User", optional: true

  before_update :restrict_updation
  before_destroy :restrict_deletion
  after_destroy { |deal| deal.images.purge }
  after_commit :publishable?, unless: ->{ is_publishable }

  validates :title, :description, :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, :published_at, presence: true 
  validates :title, uniqueness: true
  validates :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, numericality: true
  scope :number_of_deals_with_publish_date, ->(date) { where(published_at: date).size }

  def publishable?
    return true if images.size >= 2 && quantity > 10 && Deal.number_of_deals_with_publish_date(published_at) <= 2

  end

  def less_than_one_day_away_from_publish?
    (published_at - Date.today).to_i <= 1
  end

  def restrict_deletion
    throw :abort if self.less_than_one_day_away_from_publish?

  end

  def restrict_updation
    throw :abort if self.less_than_one_day_away_from_publish? && published_at_changed?

  end
end
