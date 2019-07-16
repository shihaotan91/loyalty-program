REWARDS_DATA = [
  { name: "Monthly Free Coffee", criteria: "Accumulate 100 points in one calendar month" },
  { name: "5% Cash Rebate", criteria: "Have 10 or more transactions that have an amount > $100 " },
  { name: "Free Movie Ticket", criteria: "Spend > $1000 within 60 days of their first transaction" },
  { name: "4x Airport Lounge Access", criteria: "Become a gold tier customer" }
]

namespace :setup do
  desc 'Create Rewards'
  task create_rewards: :environment do
    REWARDS_DATA.each do |data|
      Reward.create!(name: data[:name], criteria: data[:criteria])
    end
  end
end