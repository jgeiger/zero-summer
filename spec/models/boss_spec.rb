require 'spec_helper'

describe Boss do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    Boss.create!(@valid_attributes)
  end
end
