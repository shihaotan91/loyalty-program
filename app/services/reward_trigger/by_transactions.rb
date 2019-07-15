module RewardTrigger
  class ByTransactions
    def initialize(user)
      @user = user
      @transactions = user.transactions

      check_rewards
    end

    def check_rewards
      give_cash_rebate
    end

    def give_cash_rebate
      reward = Reward.find_by(name: "5% Cash Rebate")
      return if @user.rewards.find_by(id: reward.id)

      return unless has_number_of_transactions_with_amount_spent(10, 10000)

      UserReward.create!(user_id: @user.id, reward_id: reward.id)
    end

    def has_number_of_transactions_with_amount_spent(number, amount)
      spendings = @transactions.pluck(:total_spent_in_cents)
      spendings.select { |spent| spent > amount }.count >= number
    end
  end
end