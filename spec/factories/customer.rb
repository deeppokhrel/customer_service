# spec/factories/customers.rb
FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.full_address }

    trait :invalid do
      name { nil }
      email { 'invalid-email' }
      phone { nil }
      address { nil }
    end
  end
end
