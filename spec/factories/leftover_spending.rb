FactoryBot.define do
  factory :leftover_spending do
    local_spent_in_cents { 0 }
    overseas_spent_in_cents { 0 }
  end
end