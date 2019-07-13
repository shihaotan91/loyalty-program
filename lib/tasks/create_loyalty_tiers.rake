LOYALTY_TIERS_DATA = [
  { name: "Standard", points_required: 0 },
  { name: "Gold", points_required: 1000 },
  { name: "Platinum", points_required: 5000 }
]

namespace :setup do
  desc 'Create Loyalty Tiers'
  task create_loyalty_tiers: :environment do
    LOYALTY_TIERS_DATA.each do |data|
      LoyaltyTier.create!(name: data[:name], points_required: data[:points_required])
    end
  end
end