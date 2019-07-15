require "rails_helper"

describe Reward do
  describe "associations" do
    it { is_expected.to have_many(:user_rewards) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
  end
end