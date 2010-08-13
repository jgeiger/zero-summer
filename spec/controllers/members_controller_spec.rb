require 'spec_helper'

describe MembersController do

  #Delete this example and add some real ones
  it "should use MembersController" do
    controller.should be_an_instance_of(MembersController)
  end

  describe "index" do

    def do_get
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end

  end

end
