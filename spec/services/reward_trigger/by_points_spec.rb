require "rails_helper"

describe RewardTrigger::ByPoints do
  subject { RewardTrigger::ByPoints }
  let(:user) { create :user }
  let!(:monthly_point) { user.monthly_points[0] }
  let!(:reward) { create :reward, name: "Monthly Free Coffee" }

  describe "give monthly free coffee" do
    describe "when user has not claimed monthly coffee reward" do
      it "creates a new coffee reward for user with 100 or more monthly points" do
        monthly_point.points = 200
        subject.new(monthly_point)

        expect(user.rewards.count).to eq 1
        expect(user.rewards[0]).to eq reward
      end

      it "does nothing when user has less than 100 monthly points" do
        monthly_point.points = 99
        subject.new(monthly_point)

        expect(user.rewards.count).to eq 0
      end
    end

    describe "when user has claimed monthly coffee reward" do
      let!(:coffee_reward) { create :user_reward, user_id: user.id, reward_id: reward.id }

      it "does nothing when user has already claimed a reward for that month" do
        expect(user.rewards.count).to eq 1
        expect(user.rewards[0]).to eq reward

        monthly_point.points = 200
        subject.new(monthly_point)

        expect(user.rewards.count).to eq 1
      end
    end
  end
end