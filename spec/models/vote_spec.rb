require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :votable_type }
  it "should allow valid values" do
    [1,-1].each do |v|
      should allow_value(v).for(:value)
    end
  end
  it { should_not allow_value(0).for(:value) }
  it { should_not allow_value(nil).for(:value) }
end
