require 'sqlite3'

def display_stats
	begin
		# open database connection
		db = SQLite3::Database.open "lib/db/data.db"

		# sql query to get total number of records
		total_query = "SELECT 
			(SELECT COUNT(Id) FROM businesses) as bus_count, 
			(SELECT COUNT(Id) FROM users) as usr_count"

		# sql query to get total number of valid records
		valid_query = "SELECT 
			(SELECT COUNT(valid) FROM businesses WHERE valid = 1) as bus_count, 
			(SELECT COUNT(valid) FROM users WHERE valid = 1) as usr_count"

		# sql query to get total number of invalid records
		invalid_query = "SELECT 
			(SELECT COUNT(valid) FROM businesses WHERE valid = 0) as bus_count, 
			(SELECT COUNT(valid) FROM users WHERE valid = 0) as usr_count"

		# sql query to get number of unique businesses
		unique_bus_query = "SELECT COUNT(DISTINCT Name) FROM businesses WHERE valid = 1"
		
		# sql query to get number of unique users
		unique_usr_query = "SELECT COUNT(DISTINCT Email) FROM users WHERE valid = 1"

		total_records = get_multi_count db, total_query
		valid_records = get_multi_count db, valid_query
		invalid_records = get_multi_count db, invalid_query
		unique_bus_records = get_count db, unique_bus_query
		unique_usr_records = get_count db, unique_usr_query

		# display the statistics about the csv records
		STDOUT.puts "Total Records Read: #{total_records}"
		STDOUT.puts "Well Formed Records Read: #{valid_records}"
		STDOUT.puts "Malformed Records Read: #{invalid_records}"
		STDOUT.puts "Unique Valid Businesses: #{unique_bus_records}"
		STDOUT.puts "Unique Valid Users: #{unique_usr_records}"
		STDOUT.puts ""

		# catch and display any sqlite exceptions that are thrown
		rescue SQLite3::Exception => e
			puts "Exception occurred"
			puts e
			exit 1
		ensure
			# close the database connection
			db.close if db
	end
end

# count the results when querying both database tables
def get_multi_count (db, query)
	counts = db.execute query

	bus_count = counts[0][0]
	usr_count = counts[0][1]
	return bus_count + usr_count
end

# count the results when querying a single database table
def get_count (db, query)
	count = db.execute query
	return count[0][0]
end