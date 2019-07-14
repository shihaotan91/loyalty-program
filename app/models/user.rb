class User < ApplicationRecord
  has_many :monthly_points
  has_many :user_rewards
  has_many :rewards, through: :user_rewards, source: :reward
  has_one :leftover_spending

  belongs_to :loyalty_tier

  before_validation :set_standard_loyalty_tier, on: :create
  after_create :create_monthly_point, :create_leftover_spending
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_inclusion_of :country, in: Country.all

  def set_standard_loyalty_tier
    self.loyalty_tier = LoyaltyTier.find_by(name: "Standard")
  end

  def create_monthly_point
    MonthlyPoint.create!(user_id: id)
  end

  def create_leftover_spending
    LeftoverSpending.create!(user_id: id)
  end

  def current_monthly_point
    monthly_points.find_by(start_date: Date.today.beginning_of_month)
  end
end
