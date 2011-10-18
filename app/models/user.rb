class User < ActiveRecord::Base
	#  Added by Gaurav Gargi
	attr_accessible :name, :email
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
end
