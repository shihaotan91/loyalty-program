class MonthlyPoint < ApplicationRecord
  belongs_to :user

  after_save :claim_reward, :upgrade_user_loyalty_tier, if: :saved_change_to_points?

  validates_numericality_of :points, allow_nil: false
  validates_presence_of :start_date, :end_date
  validates_uniqueness_of :user_id, scope: %i[start_date end_date]

  scope :for_year, lambda { |date|
    where(created_at: date.beginning_of_year..date.end_of_year)
  }

  def update_points(earned_points)
    self.points += earned_points
    self.save
  end

  def claim_reward
    ::RewardTrigger::ByPoints.new(self)
  end

  def upgrade_user_loyalty_tier
    gold_points = I18n.t("loyalty_tier.points.gold")
    platinum = I18n.t("loyalty_tier.name.platinum")
    return if user.current_year_points < gold_points || user.loyalty_tier.name == platinum

    user.upgrade_loyalty_tier
  end
end