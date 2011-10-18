require 'spec_helper'

describe User do

	before( :each ) do
		@attr = { :name => "Example User", :email => "user@example.com" }
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
end
