# By using the symbol :users, we get Fctory firl to simulate the User Model
Factory.define :user do |user|
	user.name									"Gaurav Gargi"
	user.email								"gargi86@hotmail.com"
	user.password							"foobar"
	user.password_confirmation	"foobar"
end