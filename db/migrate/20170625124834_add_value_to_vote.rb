class AddValueToVote < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :value, :integer
    add_index :votes, :value
  end
end
