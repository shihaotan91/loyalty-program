FactoryBot.define do
  factory :transaction do
    association :user, factory: :user
    country { Country.all.sample }
    total_spent_in_cents { 0 }
  end
end