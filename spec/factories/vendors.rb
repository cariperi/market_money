FactoryBot.define do
  factory :vendor do
    name { Faker::Commerce.vendor }
    description { Faker::Lorem.sentence }
    contact_name { Faker::Name.name }
    contact_phone { Faker::Address.community }
    credit_accepted { Faker::Boolean.boolean }
  end
end
