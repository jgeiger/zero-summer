require 'spec_helper'

describe MembersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/members" }.should route_to(:controller => "members", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/members/new" }.should route_to(:controller => "members", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/members/1" }.should route_to(:controller => "members", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/members/1/edit" }.should route_to(:controller => "members", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/members" }.should route_to(:controller => "members", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/members/1" }.should route_to(:controller => "members", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/members/1" }.should route_to(:controller => "members", :action => "destroy", :id => "1") 
    end
  end
end
