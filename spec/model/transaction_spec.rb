require "rails_helper"

describe Transaction do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_inclusion_of(:country).in_array(Country.all) }
    it { is_expected.to validate_numericality_of(:total_spent_in_cents) }
  end

  describe "scope" do
    let(:current_month_transaction) { create :transaction }
    let(:user) { current_month_transaction.user }

    Timecop.travel(Date.today + 1.month)
    let(:next_month_transaction) { create :transaction, user_id: user.id }
    Timecop.travel(Date.today - 1.month)

    describe "for_date_range" do
      it "returns the transactions within given date range" do
        transactions = user.transactions.for_date_range(Date.today, Date.tomorrow)
        expect(transactions.count).to eq 1
        expect(transactions[0]).to eq current_month_transaction
      end
    end
  end

  describe "instance methods" do
    let(:transaction) { create :transaction }
    let(:user) { transaction.user }

    describe "update_monthtly_points_and_leftover_spend" do
      describe "when transaction is overseas" do
        it "updates monthly points and leftover spend" do
          transaction.total_spent_in_cents = 15000
          transaction.save

          expect(user.leftover_spending.overseas_spent_in_cents).to eq 5000
          expect(user.monthly_points[0].points).to eq 20
        end
      end

      describe "when transaction is overseas" do
        it "updates monthly points and leftover spend" do
          transaction.country = user.country
          transaction.total_spent_in_cents = 15000
          transaction.save

          expect(user.leftover_spending.local_spent_in_cents).to eq 5000
          expect(user.monthly_points[0].points).to eq 10
        end
      end
    end
  end
end