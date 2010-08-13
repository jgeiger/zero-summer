require 'spec_helper'

describe "/members/index.html.haml" do
  include MembersHelper

  before(:each) do
    assigns[:members] = [
      Factory.create(:member),
      Factory.create(:member)
    ].paginate
  end

  it "renders a list of members" do
    render
  end
end
