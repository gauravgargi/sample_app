require 'spec_helper'

describe UsersController do

	render_views

  describe "GET 'new'" do
    
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  	
  	it "should have the right title" do
  		get 'new'
  		response.should have_selector("title", :content => 'Sign Up')
  	end  
  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory.build(:user)
      @user.should be_valid
      # Stubbing approach below. This way Controller test would NOT directly hit the DB.
      # This says that whenever there is a call to User.find, intercept it, and return the object @user. 
      # User.stub!(:find, @user.id).and_return(@user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
      # assigns( :symbol) returns back the instance variable of :symbol
    end
  end
end
