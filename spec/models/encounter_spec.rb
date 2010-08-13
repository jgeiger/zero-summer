require 'spec_helper'

describe Encounter do
  before(:each) do
    @valid_attributes = {
      :dungeon_id => 1,
      :boss_id => 1,
      :difficulty => "value for difficulty"
    }
  end

  it "should create a new instance given valid attributes" do
    Encounter.create!(@valid_attributes)
  end
end
