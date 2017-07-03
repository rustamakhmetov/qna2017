class AddRatingToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :rating, :integer, default: 0
  end
end
