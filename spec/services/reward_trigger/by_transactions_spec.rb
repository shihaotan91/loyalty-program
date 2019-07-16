require "rails_helper"

describe RewardTrigger::ByTransactions do
  let!(:user) { create :user }
  let(:subject) { RewardTrigger::ByTransactions }

  describe "give cash rebate" do
    let!(:cash_rebate_reward) { create :reward, name: "5% Cash Rebate" }

    describe "when user has not claimed cash rebate reward" do
      describe "when user has 10 or more transactions with required amount" do
        before do
          create_list :transaction, 10, user_id: user.id, total_spent_in_cents: 10001
        end

        it "creates a cash rebate reward for user" do
          subject.new(user)

          expect(user.rewards.count).to eq 1
          expect(user.rewards[0]).to eq cash_rebate_reward
        end
      end

      describe "when user has 10 or more transactions with required amount" do
        before do
          create_list :transaction, 10, user_id: user.id, total_spent_in_cents: 9999
        end

        it "does not create a reward for user" do
          subject.new(user)

          expect(user.rewards.count).to eq 0
        end
      end
    end

    describe "when user already claimed cash rebate reward" do
      before do
        create :user_reward, user_id: user.id, reward_id: cash_rebate_reward.id 
        create_list :transaction, 10, user_id: user.id, total_spent_in_cents: 10001
      end  

      it "does not create a reward for user" do
        expect(user.rewards.count).to eq 1
        expect(user.rewards[0]).to eq cash_rebate_reward

        subject.new(user)

        expect(user.rewards.count).to eq 1
      end
    end
  end

  describe "give movie tickets" do
    let!(:movie_ticket_reward) { create :reward, name: "Free Movie Ticket" }

    describe "when user has not claimed cash rebate reward" do
      describe "when user has spent more than required amount" do
        describe "in 60days of first transaction" do
          before do
            create_list :transaction, 3, user_id: user.id, total_spent_in_cents: 30000
            create_list :transaction, 1, user_id: user.id, total_spent_in_cents: 11000, created_at: (Date.today + 1.months).to_s
          end

          it "create movie ticket rewards for user" do
            latest_transaction = user.transactions.order(:created_at).last
            subject.new(user, latest_transaction)

            expect(user.rewards.count).to eq 1
            expect(user.rewards[0]).to eq movie_ticket_reward
          end
        end

        describe "not in 60days of first transaction" do
          before do
            create_list :transaction, 3, user_id: user.id, total_spent_in_cents: 30000
            create_list :transaction, 1, user_id: user.id, total_spent_in_cents: 11000, created_at: (Date.today + 3.months).to_s
          end

          it "does not create movie ticket rewards for user" do
            latest_transaction = user.transactions.order(:created_at).last
            subject.new(user, latest_transaction)

            expect(user.rewards.count).to eq 0
          end
        end

      end

      describe "when user has not spent more than required amount" do
        before do
          create_list :transaction, 4, user_id: user.id, total_spent_in_cents: 10000
        end

        it "does not create movie ticket rewards for user" do
          latest_transaction = user.transactions.order(:created_at).last
          subject.new(user, latest_transaction)

          expect(user.rewards.count).to eq 0
        end
      end
    end
  end
end