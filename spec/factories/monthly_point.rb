FactoryBot.define do
  factory :monthly_point do
    association :user, factory: :user
    points { 0 }
    start_date { Date.today.beginning_of_month }
    end_date { Date.today.end_of_month.end_of_day }
  end
end