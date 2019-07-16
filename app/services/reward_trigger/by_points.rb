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
      return unless @points >= I18n.t("rewards.points.coffee")

      free_coffee_reward = Reward.find_by(name: I18n.t("rewards.name.coffee"))
      return if free_coffee_reward.nil?

      this_month_coffee = @user.user_rewards.this_month.find_by(reward_id: free_coffee_reward.id)

      return if this_month_coffee
      UserReward.create!(user_id: @user.id, reward_id: free_coffee_reward.id)
    end
  end
end