require 'spec_helper'

describe Loot do
  before(:each) do
    @valid_attributes = {
      :status => "value for status",
      :member_id => 1,
      :raid_id => 1,
      :drop_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Loot.create!(@valid_attributes)
  end
end
