module RewardTrigger
  class ByTransactions
    def initialize(user, transaction)
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
      cash_rebate_reward = Reward.find_by(name: "5% Cash Rebate")
      return if @user.rewards.find_by(id: cash_rebate_reward.id)

      return unless number_of_transactions_with_amount_spent(10000) >= 10

      UserReward.create!(user_id: @user.id, reward_id: cash_rebate_reward.id)
    end

    def give_movie_tickets
      movie_ticket_reward = Reward.find_by(name: "Free Movie Ticket")
      return if @user.rewards.find_by(id: movie_ticket_reward.id)

      first_transaction_date = @transactions.order(:created_at).first.created_at.to_date
      return if days_since_date(first_transaction_date) > 60

      transactions_in_60_days = @transactions.for_date_range(
        first_transaction_date, @current_transaction.created_at.to_date
      )
      return if transactions_in_60_days.pluck(:total_spent_in_cents).sum < 100000

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