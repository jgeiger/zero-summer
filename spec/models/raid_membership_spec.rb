require 'spec_helper'

describe RaidMembership do
  before(:each) do
    @valid_attributes = {
      :member_id => 1,
      :raid_id => 1,
      :active => false
    }
  end

  it "should create a new instance given valid attributes" do
    RaidMembership.create!(@valid_attributes)
  end
end
