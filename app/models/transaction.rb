class Transaction < ApplicationRecord
  belongs_to :user
  after_save :update_monthtly_points_and_leftover_spend, :claim_reward

  validates_inclusion_of :country, in: Country.all
  validates_numericality_of :total_spent_in_cents, allow_nil: false

  def update_monthtly_points_and_leftover_spend
    ActiveRecord::Base.transaction do
      update_user_monthly_points
      update_user_leftover_spending
    end
  end

  def update_user_leftover_spending
    leftover_spent_in_cents = CalculatePoints.leftover_spent(total_spent_in_cents)
    puts leftover_spent_in_cents
    return unless leftover_spent_in_cents.positive?

    if overseas?
      user.leftover_spending.overseas_spent_in_cents += leftover_spent_in_cents
    else
      user.leftover_spending.local_spent_in_cents += leftover_spent_in_cents
    end

    user.leftover_spending.update_monthly_points_and_leftover_spend
  end

  def update_user_monthly_points
    total_points_earned = CalculatePoints.points_earned(total_spent_in_cents)
    return if total_points_earned.zero?

    total_points_earned *= 2 if overseas?
    user.current_monthly_point.update_points(total_points_earned)
  end

  def overseas?
    user.country != country
  end

  def claim_reward
    ::RewardTrigger::ByTransactions.new(user)
  end
end