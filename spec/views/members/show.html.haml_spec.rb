require 'spec_helper'

describe "/members/show.html.haml" do
  include MembersHelper
  before(:each) do
    assigns[:member] = @member = Factory.create(:member)
  end

  it "renders attributes in <p>" do
    render
  end
end
