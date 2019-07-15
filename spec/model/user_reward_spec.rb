require "rails_helper"

describe UserReward do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:reward) }
  end

  describe "scope" do
    let!(:this_month_reward) { create :user_reward }
    let!(:user) { this_month_reward.user }

    describe "this month" do
      before do
        Timecop.travel(Date.today + 1.month)
        create :user_reward, user_id: user.id
      end

      it "returns all rewards that are created in current month" do
        Timecop.travel(Date.today - 1.month)

        expect(user.user_rewards.this_month.count).to eq 1
        expect(user.user_rewards.this_month[0]).to eq this_month_reward
      end
    end
  end
end