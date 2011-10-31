class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy


  def index
  	# @users = User.all
  	@users = User.order('created_at ASC').paginate(:per_page => 2, :page => params[:page])
  	@title = "All Users"
	end

  def new
  	@user = User.new
  	@title = "Sign Up"
  end

  def show
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		# below added in Ch9-- To go to the user page after new user creation
  		sign_in @user
  		# sign_in is a method written in SessionsHelper.rb
  		flash[:success] = "Welcome to the Sample App!!"
  		redirect_to @user
  	else
  		@title = "Sign Up"
  		render 'new'
  	end
  end

  def edit
  	# @user = User.find(params[:id])
  	# Above line Not reqd as we now have it in correct_user method 
  	@title = "Edit User"
  end

  def update
  	# @user = User.find(params[:id])
  	# Above line not reqd as we have it in correct_user method
  	if @user.update_attributes(params[:user])
  		flash[:success] = "Profile Updated"
  		redirect_to @user
  	else
  		@title = "Edit User"
  		render 'edit'
  	end
  end


  def destroy
  	User.find(params[:id]).destroy
  	flash[:success] = "User Destroyed"
  	redirect_to users_path
	end

  private
  	
  	def authenticate
  		deny_access unless signed_in?
  		# deny_access  and signed_in  defined in SessionsHelper
  	end

  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_path) unless current_user?(@user) 
  	end

  	def admin_user
  		redirect_to(root_path) unless current_user.admin?
  	end
end
