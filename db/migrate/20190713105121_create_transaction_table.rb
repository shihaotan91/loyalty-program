class CreateTransactionTable < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :user, index: true
      t.integer :leftover_spent_in_cents
      t.integer :total_spent_in_cents
      t.string  :country

      t.timestamps null: false
    end
  end
end
