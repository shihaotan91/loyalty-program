class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.string :name
      t.string :criteria

      t.timestamps null: false
    end
  end
end
