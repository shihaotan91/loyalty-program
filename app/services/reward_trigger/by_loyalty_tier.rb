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
      return if @loyalty_tier.name != "Gold"

      airport_reward = Reward.find_by(name: "4x Airport Lounge Access")
      return if airport_reward.nil? || @user.rewards.find_by(id: airport_reward.id)

      UserReward.create!(user_id: @user.id, reward_id: airport_reward.id)
    end
  end
end