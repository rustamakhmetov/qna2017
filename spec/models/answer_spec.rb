require 'rails_helper'

describe Answer do
  it { should belong_to :user}
  it { should belong_to :question}
  it { should validate_presence_of :body}
  it { should have_db_column(:accept) }
end