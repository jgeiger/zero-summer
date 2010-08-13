require 'spec_helper'

describe Absence do
  before(:each) do
    @valid_attributes = {
      :member_id => 1,
      :event_date => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    Absence.create!(@valid_attributes)
  end
end
