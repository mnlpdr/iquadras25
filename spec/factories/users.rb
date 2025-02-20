FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { :client }

    trait :admin do
      role { :admin }
    end

    trait :court_owner do
      role { :court_owner }
    end
  end
end 