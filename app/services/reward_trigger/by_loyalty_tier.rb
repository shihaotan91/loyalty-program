module RewardTrigger
  class ByLoyaltyTier
    def initialize(user)
      @user = user
      @loyalty_tier = user.loyalty_tier

      check_rewards
    end

    def check_rewards
      give_airport_lounge_access
    end

    def give_airport_lounge_access
      return if @loyalty_tier.name != I18n.t("loyalty_tier.name.gold")

      airport_reward = Reward.find_by(name: I18n.t("rewards.name.airport_access"))
      return if airport_reward.nil? || @user.rewards.find_by(id: airport_reward.id)

      UserReward.create!(user_id: @user.id, reward_id: airport_reward.id)
    end
  end
end