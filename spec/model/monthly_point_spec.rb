require "rails_helper"

describe MonthlyPoint do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_numericality_of(:points) }
  end

  describe "instance methods" do
    let(:monthly_point) { create :monthly_point, points: 100}
    let(:user) { monthly_point.user }

    describe "update points" do
      it "updates the points" do
        monthly_point.update_points(500)
        expect(monthly_point.points).to eq 600
      end
    end

    describe "upgrade_user_loyalty_tier" do
      let(:platinum) { create :loyalty_tier, :platinum }

      before do
        allow(user).to receive(:upgrade_loyalty_tier)
      end

      describe "when user has less than 1000 points" do
        it "does not invoke user upgrade_loyalty_tier method" do
          monthly_point.points = 500
          monthly_point.save

          expect(user).not_to have_received(:upgrade_loyalty_tier)
        end
      end

      describe "when user has more than 1000points but already has platinum loyalty tier" do
        it "does not invoke user upgrade_loyalty_tier method" do
          user.loyalty_tier = platinum
          user.save

          monthly_point.points = 1500
          monthly_point.save

          expect(user).not_to have_received(:upgrade_loyalty_tier)
        end
      end

      describe "when user has more than 1000points and isn't a platinum member" do
        it "invokes user upgrade_loyalty_tier method" do
          monthly_point.points = 1500
          monthly_point.save

          expect(user).to have_received(:upgrade_loyalty_tier)
        end
      end
    end
  end
end