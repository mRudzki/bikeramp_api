require 'faker'

FactoryBot.define do
  factory :trip do
    start_address { Faker::Address.full_address }
    destination_address { Faker::Address.full_address }
    price { 20 }
    date { Date.today }
  end
end
