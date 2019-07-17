class User < ApplicationRecord
  has_many :monthly_points, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :user_rewards, dependent: :destroy
  has_many :rewards, through: :user_rewards, source: :reward
  has_one :leftover_spending, dependent: :destroy

  belongs_to :loyalty_tier

  after_save :claim_reward, if: :saved_change_to_loyalty_tier_id?

  before_validation :set_standard_loyalty_tier, on: :create
  after_create :create_monthly_point, :create_leftover_spending

  devise :database_authenticatable, :registerable, :validatable

  validates_inclusion_of :country, in: Country.all
  validates_presence_of :name, :email

  def set_standard_loyalty_tier
    self.loyalty_tier = LoyaltyTier.find_by(name: I18n.t("loyalty_tier.name.standard"))
  end

  def create_monthly_point
    month_start = Date.today.beginning_of_month
    month_end = Date.today.end_of_month.end_of_day
    MonthlyPoint.create!(user_id: id, start_date: month_start, end_date: month_end)
  end

  def create_leftover_spending
    LeftoverSpending.create!(user_id: id)
  end

  def current_monthly_point
    monthly_points.find_by(start_date: Date.today.beginning_of_month)
  end

  def current_year_points
    date = Date.today
    monthly_points.for_year(date).pluck(:points).sum
  end

  def upgrade_loyalty_tier(points=current_year_points)
    ::LoyaltyTier::POINTS_NEEDED.keys.each do |tier|
      if can_upgrade_loyalty_tier(tier, points)
        qualified_tier = LoyaltyTier.find_by(name: tier)
        next unless qualified_tier
        self.loyalty_tier = qualified_tier
        self.save
        break
      end
    end
  end

  def claim_reward
    ::RewardTrigger::ByLoyaltyTier.new(self)
  end

  def can_upgrade_loyalty_tier(tier, points)
    points >= ::LoyaltyTier::POINTS_NEEDED[tier] &&
      loyalty_tier.name != tier
  end
end
