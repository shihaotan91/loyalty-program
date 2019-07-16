require "rails_helper"

describe RewardTrigger::ByLoyaltyTier do
  subject { RewardTrigger::ByLoyaltyTier }
  let(:user) { create :user }
  let(:gold) { create :loyalty_tier, :gold }
  let!(:reward) { create :reward, name: "4x Airport Lounge Access" }
  let(:subject) { RewardTrigger::ByLoyaltyTier }

  describe "give airport lounge access" do
    describe "when user has not claimed airport lounge access reward" do
      it "creates a user reward when user is a gold tier member" do
        user.loyalty_tier = gold
        subject.new(user)

        expect(user.rewards.count).to eq 1
        expect(user.rewards[0]).to eq reward
      end

      it "does nothing when user is not a gold tier member" do
        subject.new(user)

        expect(user.rewards.count).to eq 0
      end
    end

    describe "when user has claimed airport lounge access reward" do
      let!(:airport_reward) { create :user_reward, user_id: user.id, reward_id: reward.id }

      it "does nothing when user has already claimed that reward" do
        expect(user.rewards.count).to eq 1
        expect(user.rewards[0]).to eq reward

        user.loyalty_tier = gold
        subject.new(user)

        expect(user.rewards.count).to eq 1
      end
    end
  end
end