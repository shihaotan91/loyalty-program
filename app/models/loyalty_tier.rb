class LoyaltyTier < ApplicationRecord
  has_many :users

  validates_presence_of :name, :points_required
end