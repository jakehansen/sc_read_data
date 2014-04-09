require 'sqlite3'

# initialize the database
def db_init
	STDERR.puts "Initializing Database..."
	begin
		# open database connection
		db = SQLite3::Database.new "lib/db/data.db"

		create_business_table db
		create_user_table db

		# catch and display any sqlite exceptions that are thrown
		rescue SQLite3::Exception => e
			puts "Exception occurred"
			puts e
			exit 1
		ensure
			# close the database connection
			db.close if db
	end
	STDERR.puts "complete"
end

# drop old business data and create a new busineses table
def create_business_table (db)
	db.execute "DROP TABLE IF EXISTS businesses"

	db.execute "CREATE TABLE IF NOT EXISTS businesses (
	Id INTEGER PRIMARY KEY AUTOINCREMENT,
	Name TEXT NULL,
	Address TEXT NULL,
	City TEXT NULL,
	State TEXT NULL,
	Zip TEXT NULL,
	Phone TEXT NULL,
	Fax TEXT NULL,
	Email TEXT NULL,
	Valid INTEGER NULL,
	Errors TEXT NULL)"
end

# drop old user data and create a new users table
def create_user_table (db)
	db.execute "DROP TABLE IF EXISTS users"
	
	db.execute "CREATE TABLE IF NOT EXISTS users (
		Id INTEGER PRIMARY KEY AUTOINCREMENT,
		Name TEXT NULL,
		Email TEXT NULL,
		Phone TEXT NULL,
		Title TEXT NULL,
		BusinessName TEXT NULL,
		Valid INTEGER NULL,
		Errors TEXT NULL)"
end