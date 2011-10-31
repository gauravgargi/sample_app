class User < ActiveRecord::Base
	#  Added by Gaurav Gargi
	attr_accessor :password
	# The above line creates a virtual attribute password.
	# By virtual, we mean that this attribute is not going to be there in the DB
	attr_accessible :name, :email, :password, :password_confirmation
	# Telling Rails which attributes can be modified by outside users

	# regex = //i   # i= case-insensitive
	# 			= /[]@[]\.[]/i 												# [] @ [] \. []  Generic format
	# 																						# \. 						literal dot
 	# 			= /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i    # [\w+\-.]+			Atleast 1 word character, hyphen or dot
 	# 	 																					# [a-z]+  			Atleast 1 letter
 	#																		 					# [a-z\d\-.]+   Atleast 1 letter, digit, hypen, or dot
 	# 			= /\A@[a-z\d\-.]+\.[a-z]+/i 					# \A  					Match start of a string
 	#																							# \z						Match end of  string

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	# validates_presence_of( :name ) is a Rails 2.3 syntax
	validates( :name, :presence => true,
										:length => { :maximum => 50 })
	validates( :email, :presence => true,
										 :uniqueness => { :case_sensitive => false },
										 :format => { :with => email_regex })
	# The below line automatically cretaes a virtual attribute password_confirmation
	validates( :password, :confirmation => true,
												:presence => true,
												:length => { :within => 6..40})
	before_save :encrypt_password

	# Returns true if the user's password matches with the submitted password
	def has_password?(submitted_password)
		# Compare encrypted password with the encrypted version of the submitted password
		encrypted_password == encrypt(submitted_password)
	end

	# def self.authenticate(email,submitted_password)
	# 	user = find_by_email(email)
	# 	return nil if user.nil?
	# 	return user if user.has_password?(submitted_password)
	# end

	# def User.authenticate(email, submitted_password)
 #    user = find_by_email(email)
 #    return nil  if user.nil?
 #    return user if user.has_password?(submitted_password)
 #  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
    return nil
  end
 
	# Ch 9. RoR Tut 
 	def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    # (user && user.salt == cookie_salt) ? user : nil
    return nil  if user.nil?
	  return user if user.salt == cookie_salt
  end
  # def self.authenticate(email, submitted_password)
  #   user = find_by_email(email)
  #   if user.nil?
  #     nil
  #   elsif user.has_password?(submitted_password)
  #     user
  #   else
  #     nil
  #   end
  # end

  # def self.authenticate(email, submitted_password)
  #   user = find_by_email(email)
  #   if user.nil?
  #     nil
  #   elsif user.has_password?(submitted_password)
  #     user
  #   end
  # end

  # def self.authenticate(email, submitted_password)
  #   user = find_by_email(email)
  #   user && user.has_password?(submitted_password) ? user : nil
  # end

	private

		def encrypt_password
			self.salt = make_salt unless has_password?(password)
			# self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
			# self is the current user object,
			# and encrypted_password is the attribute name in User model
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
