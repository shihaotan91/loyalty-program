class CreateUserRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :user_rewards do |t|
      t.references :user, index: true
      t.references :reward, index: true
      t.string :identifier
      t.boolean :redeemed, default: false

      t.timestamps null: false
    end
  end
end
