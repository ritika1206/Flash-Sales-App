class Deal < ApplicationRecord
  has_many_attached :images
  belongs_to :admin, class_name: "User"
  after_save :publishable?, unless: ->{ is_publishable }

  validates :title, :description, :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, :published_at, presence: true 
  validates :title, uniqueness: true
  validates :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, numericality: true
  scope :number_of_deals_with_publish_date, ->(date) { where(published_at: date).size }

  private
    def publishable?
      if images.size >= 2 && quantity > 10 && number_of_deals_with_publish_date(date) <= 2
        update!(is_publishable: true)
      else
        update!(is_publishable: false)
      end
    end
end
