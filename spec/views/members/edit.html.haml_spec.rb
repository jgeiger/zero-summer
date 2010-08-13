require 'spec_helper'

describe "/members/edit.html.haml" do
  include MembersHelper

  before(:each) do
    assigns[:member] = @member = Factory.create(:member)
    assigns[:other_members] = []
  end

  it "renders the edit member form" do
    render
    response.should have_tag("form[action=/members/#{@member.id}][method=post]") do
    end
  end
end
