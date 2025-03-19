FactoryBot.define do
  factory :notification_log do
    notification_type { "MyString" }
    user_id { 1 }
    reservation_id { 1 }
    status { "MyString" }
    error_message { "MyText" }
    sent_at { "2025-02-20 18:15:31" }
  end
end
