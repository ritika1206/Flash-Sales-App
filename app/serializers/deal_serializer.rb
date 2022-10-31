class DealSerializer < ActiveModel::Serializer
  attributes :title, :description, :price_in_cents, :discount_price_in_cents, :initial_quantity, :tax_percentage, :published_at, :status 
end
