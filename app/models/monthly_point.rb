class MonthlyPoint < ApplicationRecord
  belongs_to :user

  after_save :claim_reward, :upgrade_loyalty_tier
  before_validation :generate_start_and_end_dates, on: :create

  validates :user_id, uniqueness: { scope: %i[start_date end_date] }

  scope :this_year, -> { where(created_at: DateTime.now.beginning_of_year..DateTime.now.end_of_year) }

  def generate_start_and_end_dates
    today = Date.today
    self.start_date = today.beginning_of_month
    self.end_date = today.end_of_month.end_of_day
  end

  def update_points(earned_points)
    self.points += earned_points
    self.save
  end

  def claim_reward
    ::RewardTrigger::ByPoints.new(self)
  end

  def upgrade_loyalty_tier
    return if user.current_year_points < 1000 || user.loyalty_tier.name == "Platinum"

    ::LoyaltyTier::POINTS_NEEDED.keys.each do |tier|
      if can_upgrade(tier)
        user.upgrade_loyalty_tier(tier)
        break
      end
    end
  end

  def can_upgrade(tier)
    user.current_year_points >= ::LoyaltyTier::POINTS_NEEDED[tier] &&
      user.loyalty_tier.name != tier
  end
end