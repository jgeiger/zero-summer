require 'spec_helper'

describe Drop do
  before(:each) do
    @valid_attributes = {
      :encounter_id => 1,
      :item_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Drop.create!(@valid_attributes)
  end
end
