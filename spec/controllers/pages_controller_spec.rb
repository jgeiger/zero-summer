require 'spec_helper'

describe PagesController do

  #Delete this example and add some real ones
  it "should use PagesController" do
    controller.should be_an_instance_of(PagesController)
  end

  describe "home" do

    def do_get
      get :home
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render home template" do
      do_get
      response.should render_template('home')
    end

  end

end
