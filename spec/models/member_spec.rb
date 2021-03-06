require 'spec_helper'

describe Member do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :klass => "value for klass",
      :role => "value for role",
      :rank => "value for rank"
    }
  end

  it "should create a new instance given valid attributes" do
    Member.create!(@valid_attributes)
  end
end
