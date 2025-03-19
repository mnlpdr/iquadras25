FactoryBot.define do
  factory :payment do
    reservation { nil }
    user { nil }
    amount { "9.99" }
    status { 1 }
    stripe_payment_id { "MyString" }
    stripe_payment_intent_id { "MyString" }
    metadata { "" }
  end
end
