require 'spec_helper'

describe Adjustment do
  before(:each) do
    @valid_attributes = {
      :amount => 1,
      :member_id => 1,
      :loot_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Adjustment.create!(@valid_attributes)
  end
end
