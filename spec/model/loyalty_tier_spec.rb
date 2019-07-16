require "rails_helper"

describe LoyaltyTier do
  describe "associations" do
    it { is_expected.to have_many(:users) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :points_required }
  end
end