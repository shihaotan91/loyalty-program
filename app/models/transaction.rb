class Transaction < ApplicationRecord
  belongs_to :user

  after_create :update_user_monthly_points, :calculate_leftover_spent

  belongs_to :user

  validates_inclusion_of :country, in: Country.all
  validates_numericality_of :total_spent_in_cents, allow_nil: false

  def calculate_leftover_spent
    leftover_spent_in_cents = CalculatePoints.leftover_spent(total_spent_in_cents)
    return unless leftover_spent_in_cents.positive?

    if overseas?
      user.leftover_spending.overseas_spent_in_cents += leftover_spent_in_cents
    else
      user.leftover_spending.local_spent_in_cents += leftover_spent_in_cents
    end

    user.leftover_spending.save
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
end