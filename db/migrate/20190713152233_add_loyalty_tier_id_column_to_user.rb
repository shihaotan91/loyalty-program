class AddLoyaltyTierIdColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :loyalty_tier, index: true
  end
end
