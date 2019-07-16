require "rails_helper"

describe LeftoverSpending do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_numericality_of(:local_spent_in_cents) }
    it { is_expected.to validate_numericality_of(:overseas_spent_in_cents) }
  end

  describe "instance methods" do
    let(:user) { create :user }
    let(:leftover_spending) { user.leftover_spending }

    describe "update_monthly_points_and_leftover_spend" do
      describe "when spending is local" do
        it "updates local spent in cents and user monthly points" do
          leftover_spending.local_spent_in_cents = 15000
          leftover_spending.update_monthly_points_and_leftover_spend

          expect(leftover_spending.local_spent_in_cents).to eq 5000
          expect(user.monthly_points[0].points).to eq 10
        end
      end
    end

    describe "update_monthly_points_and_leftover_spend" do
      describe "when spending is local" do
        it "updates local spent in cents and user monthly points" do
          leftover_spending.overseas_spent_in_cents = 15000
          leftover_spending.update_monthly_points_and_leftover_spend

          expect(leftover_spending.overseas_spent_in_cents).to eq 5000
          expect(user.monthly_points[0].points).to eq 20
        end
      end
    end
  end
end