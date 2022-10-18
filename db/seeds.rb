Deal.delete_all
User.delete_all

3.times do |i|
  User.create!(
    name: "user#{'h' * i}",
    email: "user#{i}@flash.com",
    password: 'userrr',
    password_confirmation: 'userrr',
    verified_at: Time.current
  )
end

puts "Successfully created users"

admin = User.create!(
  name: 'Rit',
  email: 'rit@flash.com',
  password: 'ritrit',
  password_confirmation: 'ritrit',
  role: 'admin',
  verified_at: Time.current
)

puts "Successfully created admin"

5.times do |i|
  deal = admin.deals.create!(
    title: "Snacks Deal #{i}",
    description: 'lorem ipsum',
    price_in_cents: 10000 + i,
    discount_price_in_cents: 8000 + i,
    initial_quantity: 500 + i,
    current_quantity: 500 + i,
    tax_percentage: 2 + i,
    published_at: Date.today + i
  )

  deal.images.attach([
    {
      io: File.open(Rails.root.join('app/assets/images/seed_images/deal_img5.jpeg')),
      filename: 'deal_img5.jpeg',
      content_type: 'image/jpeg'
    },
    {
      io: File.open(Rails.root.join('app/assets/images/seed_images/deal_img6.jpeg')),
      filename: 'deal_img6.jpeg',
      content_type: 'image/jpeg'
    }
  ])
end

puts "Successfully created deals"


