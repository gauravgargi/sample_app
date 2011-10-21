require 'spec_helper'

describe User do

	before( :each ) do
		@attr = { 	:name => "Example User",
							 	:email => "user@example.com",
							 	:password => "foobar",
							 	:password_confirmation => "foobar" }
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end

	it "should require a name" do
		no_name = User.new( @attr.merge( :name => "" ))
		no_name.should_not be_valid
	end

	it "should require an email address" do
		no_email = User.new( @attr.merge( :email => "" ))
		no_email.should_not be_valid
	end	

	it "should check for length of name" do
		long_name_text = "a" * 51
		long_name = User.new( @attr.merge( :name => long_name_text))
		long_name.should_not be_valid
	end

	it "should accept valid email address formats" do
		email = %w[abc@abc.com THE_USER@abc.com first.last@abc.org]
		email.each do |email_address|
			valid_email_user = User.new(@attr.merge( :email => email_address))
			valid_email_user.should be_valid
		end
	end

	it "should reject invalid email address formats" do
		email = %w[abc@abc,com first.last.org abc@abc.]
		email.each do |email_address|
			invalid_email_user = User.new( @attr.merge( :email => email_address))
			invalid_email_user.should_not be_valid
		end
	end

	it "should reject duplicate email addresses" do
		upcased_email = @attr[:email].upcase
		User.create!(@attr.merge(:email => upcased_email))
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
	end

	# PASSWORD / PASSSWORD CONIRMATION TC
	it "should reject users with blank passwords" do
		User.new(@attr.merge( :password => "", :pasword_confirmation => ""))
		should_not be_valid
	end

	it "should match for password confirmation" do
		User.new(@attr.merge( :password_confirmation => "asdfgh"))
		should_not be_valid
	end

	it "should check for minimum length of password" do
		short = "a" * 5
		User.new(@attr.merge( :password => short, :password_confirmation => short))
		should_not be_valid
	end

	it "should check for maximum password length" do
		long = "a" * 41
		User.new(@attr.merge( :password => long, :password_confirmation => long))
		should_not be_valid
	end

	describe "password encryption" do	
		
		before(:each) do
			@user = User.create!(@attr)
		end
		# we create a user, rather than just calling User.new. We could actually 
		# get this test to pass using User.new, but 
		# setting the encrypted password will require that the user be saved to the database.
		# ENCRYPTED PASSWORD TC 
		it "should have an encrypted_password attribute" do
			@user.should respond_to(:encrypted_password)
		end

		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end


		describe "has_password? method" do

			it "should return true if paswwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end

			it "should return false if passwords dont match" do
				@user.has_password?("invalid").should be_false
			end
		end

		describe "authenticate method" do

			it "should return the user on the email/pwd match" do
				matching_user = User.authenticate(@attr[:email], @attr[:password])
				matching_user.should == @user
			end

			it "should return nil if password does not match" do
				wrong_password = User.authenticate(@attr[:email], "wrongpassword")
				wrong_password.should be_nil
			end

			it "should return nil for a non-existant user" do
				non_existant_user = User.authenticate("abc@abc.com", @attr[:password])
				non_existant_user.should be_nil
			end
		end
	end
end

