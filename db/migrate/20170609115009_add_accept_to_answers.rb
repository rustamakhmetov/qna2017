class AddAcceptToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :accept, :boolean, default: false
    add_index :answers, :accept
  end
end
