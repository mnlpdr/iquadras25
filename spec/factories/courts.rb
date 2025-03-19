FactoryBot.define do
  factory :court do
    sequence(:name) { |n| "Quadra #{n}" }
    location { "Local teste" }
    capacity { 20 }
    price_per_hour { 100.0 }
    association :owner, factory: :user, role: :court_owner
  end
end 