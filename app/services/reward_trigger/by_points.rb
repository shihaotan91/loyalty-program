module RewardTrigger
  class ByPoints
    def initialize(monthly_point)
      @user = monthly_point.user
      @points = monthly_point.points

      check_rewards
    end

    def check_rewards
      give_free_monthly_coffee
    end

    def give_free_monthly_coffee
      return unless @points >= 100

      reward = Reward.find_by(name: "Monthly Free Coffee")
      this_month_coffee = @user.user_rewards.this_month.find_by(reward_id: reward.id)

      return if this_month_coffee
      UserReward.create!(user_id: @user.id, reward_id: reward.id)
    end
  end
end