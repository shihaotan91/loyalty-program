class MonthlyPoint < ApplicationRecord
  belongs_to :user

  after_save :claim_reward, :upgrade_user_loyalty_tier
  before_validation :generate_start_and_end_dates, on: :create

  # validates_uniqueness_of :user_id, scope: %i[start_date end_date]

  scope :for_year, lambda { |date|
    where(created_at: date.beginning_of_year..date.end_of_year)
  }

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

  def upgrade_user_loyalty_tier
    return if user.current_year_points < 1000 || user.loyalty_tier.name == "Platinum"

    user.upgrade_loyalty_tier
  end
end