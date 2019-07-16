module RewardTrigger
  class ByTransactions
    def initialize(user, transaction=nil)
      @user = user
      @transactions = user.transactions
      @current_transaction = transaction

      check_rewards
    end

    def check_rewards
      give_cash_rebate
      give_movie_tickets
    end

    def give_cash_rebate
      cash_rebate_reward = Reward.find_by(name: I18n.t("rewards.name.cash_rebate"))
      return if cash_rebate_reward.nil? || @user.rewards.find_by(id: cash_rebate_reward.id)

      amount_spent = I18n.t("rewards.spent_in_cents.cash_rebate")
      required_transactions_count = I18n.t("rewards.transaction_count.cash_rebate")
      return unless number_of_transactions_with_amount_spent(amount_spent) >= required_transactions_count

      UserReward.create!(user_id: @user.id, reward_id: cash_rebate_reward.id)
    end

    def give_movie_tickets
      movie_ticket_reward = Reward.find_by(name: I18n.t("rewards.name.movie_ticket"))
      return if movie_ticket_reward.nil? || @user.rewards.find_by(id: movie_ticket_reward.id)

      first_transaction_date = @transactions.order(:created_at).first.created_at.to_date
      return if days_since_date(first_transaction_date) > I18n.t("rewards.days.movie_ticket")

      transactions_in_60_days = @transactions.for_date_range(
        first_transaction_date, @current_transaction.created_at.to_date
      )

      return if transactions_in_60_days.pluck(:total_spent_in_cents).sum < I18n.t("rewards.spent_in_cents.movie_ticket")

      UserReward.create!(user_id: @user.id, reward_id: movie_ticket_reward.id)
    end

    def number_of_transactions_with_amount_spent(amount)
      spendings = @transactions.pluck(:total_spent_in_cents)
      spendings.select { |spent| spent > amount }.count
    end

    def days_since_date(date)
      (@current_transaction.created_at.to_date - date).to_i
    end
  end
end