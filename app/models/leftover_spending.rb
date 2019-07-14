class LeftoverSpending < ApplicationRecord
  belongs_to :user

  def update_monthly_points_and_leftover_spend
    ActiveRecord::Base.transaction do
      update_user_monthly_points
      update_leftover_spent
    end
  end

  def update_leftover_spent
    self[updated_field] -= CalculatePoints.spent_converted(self[updated_field])
    self.save
  end

  def update_user_monthly_points
    total_points_earned = CalculatePoints.points_earned(self[updated_field])
    return true if total_points_earned.zero?

    total_points_earned *= 2 if updated_field == "overseas_spent_in_cents"
    user.current_monthly_point.update_points(total_points_earned)
  end

  def updated_field
    changed[0]
  end
end