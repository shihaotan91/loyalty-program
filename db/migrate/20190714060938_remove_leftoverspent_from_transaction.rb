class RemoveLeftoverspentFromTransaction < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :leftover_spent_in_cents, :integer
  end
end
