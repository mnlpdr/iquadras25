FactoryBot.define do
  factory :sport do
    sequence(:name) { |n| "Esporte #{n}" }
  end
end 