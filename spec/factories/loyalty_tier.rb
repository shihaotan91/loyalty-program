FactoryBot.define do
  factory :loyalty_tier do
    name { "Standard" }
    points_required { 0 }
  end

  trait :gold do
    name { "Gold" }
    points_required { 1000 }
  end

  trait :platinum do
    name { "Platinum" }
    points_required { 5000 }
  end
end