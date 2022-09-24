class Deal < ApplicationRecord
  has_many_attached :images

  validates :title, :description, :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, :published_at, presence: true 
  validates :title, uniqueness: true
  validates :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, numericality: true
end
