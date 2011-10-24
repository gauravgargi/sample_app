require 'spec_helper'

describe UsersController do

	render_views

  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
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

  describe "POST 'create'" do
    
    describe "failure" do
      before( :each ) do
        @attr = {  :name => "", :email => "", :password => "", :password_confirmation => "" }
      end  

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do
      before( :each ) do
        @attr = { :name=>"Gaurav",:email => "abc@abc.com", :password => "123456", :password_confirmation => "123456"}
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
    end
  end
end
