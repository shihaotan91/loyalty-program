require "rails_helper"

describe User do
  describe "associations" do
    it { is_expected.to have_many(:monthly_points) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:user_rewards) }
    it { is_expected.to have_many(:rewards).through(:user_rewards) }
    it { is_expected.to belong_to(:loyalty_tier) }
    it { is_expected.to have_one(:leftover_spending) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_inclusion_of(:country).in_array(Country.all) }
  end

  describe "instance methods" do
    let(:user) { create :user }

    describe "current_monthly_points" do
      it "returns the monthly_points of the current month" do
        expected_monthly_point = user.monthly_points.find_by(start_date: Date.today.beginning_of_month)
        expect(user.current_monthly_point).to eq expected_monthly_point
      end
    end

    describe "current_year_points" do
      before do
        create :monthly_point,
               user_id: user.id,
               points: 100,
               start_date: (Date.today + 1.month).beginning_of_month,
               end_date: (Date.today + 1.month).end_of_month.end_of_day
        create :monthly_point,
               user_id: user.id,
               points: 200,
               start_date: (Date.today - 1.month).beginning_of_month,
               end_date: (Date.today - 1.month).end_of_month.end_of_day
      end

      it "returns the summed up points of all monthly points this year" do
        expect(user.current_year_points).to eq user.monthly_points.pluck(:points).sum
      end
    end

    describe "upgrade_loyalty_tier" do
      before do
        create :loyalty_tier, :gold
        create :loyalty_tier, :platinum
      end

      describe "when user has more than 1000 points" do
        it "upgrades user to gold tier member" do
          expect(user.loyalty_tier.name).to eq "Standard"
          user.upgrade_loyalty_tier(1000)
          expect(user.loyalty_tier.name).to eq "Gold"
        end
      end

      describe "when user has more than 5000 points" do
        it "upgrades user to platinum tier member" do
          expect(user.loyalty_tier.name).to eq "Standard"
          user.upgrade_loyalty_tier(5000)
          expect(user.loyalty_tier.name).to eq "Platinum"
        end
      end
    end
  end
end