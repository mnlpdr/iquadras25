FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Usuário #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { :client }
    phone_number { "11999999999" }
    
    trait :court_owner do
      role { :court_owner }
    end

    trait :admin do
      role { :admin }
    end

    trait :client do
      role { :client }
    end
  end
end 