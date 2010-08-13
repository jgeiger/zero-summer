require 'spec_helper'

describe "/members/new.html.haml" do
  include MembersHelper

  before(:each) do
    assigns[:member] = Factory.build(:member)
  end

  it "renders new member form" do
    render

    response.should have_tag("form[action=?][method=post]", members_path) do
    end
  end
end
