class CreateLoyaltyTier < ActiveRecord::Migration[5.2]
  def change
    create_table :loyalty_tiers do |t|
      t.integer :points_required
      t.string :name

      t.timestamps null: false
    end
  end
end
