class DealSerializer < ActiveModel::Serializer
  attributes :title, :description, :price_in_cents, :discount_price_in_cents, :quantity, :tax_percentage, :published_at, :status 
end
