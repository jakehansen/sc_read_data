require 'sqlite3'
require 'csv'
require 'active_support/inflector'
require 'helpers/validate_record'

def read_csv_data
	begin
		# open database connection
		db = SQLite3::Database.open "lib/db/data.db"

		# read the businesses.csv file
		read_csv db, "business"
		# read the users.csv file
		read_csv db, "user"

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

def read_csv (db, model)
	STDERR.puts "Reading #{model} data..."

	models = model.pluralize

	# ensure that the csv file to be parsed exists
	if File.exist?("lib/csv-files/#{models}.csv")
		# parse each record in the specified file
		CSV.foreach(File.path("lib/csv-files/#{models}.csv"), :headers => true) do |record|
			# check the record for errors
			errors = is_record_valid db, record, model
			# set the record validity for storage in the database
			valid = (errors == "") ? 1 : 0
			if model == "business"
				# insert the business record into the businesses table
				insert_business db, record, valid, errors
			elsif model == "user"
				# insert the user record into the users table
				insert_user db, record, valid, errors
			end
		end
			
		STDERR.puts "complete"
	else
		# warn the user that the csv file was not found and exit with a status of 1
		STDERR.puts "The CSV file, #{models}.csv, was not found in lib/csv-files/"
		exit 1
	end
end

def insert_business (db, record, valid, errors)
	# prepare the business record for insertion into the database
	query = db.prepare "INSERT INTO businesses (Name,Address,City,State,Zip,Phone,Fax,Email,Valid,Errors) 
				VALUES('#{record[0]}','#{record[1]}','#{record[2]}','#{record[3]}','#{record[4]}',
				'#{record[5]}','#{record[6]}','#{record[7]}',#{valid},'#{errors}')" 
	# insert record
	query.execute
	ensure
		# close insert statement
		query.close if query
end

def insert_user (db, record, valid, errors)
	# prepare the user record for insertion into the database
	query = db.prepare "INSERT INTO users (Name,Email,Phone,Title,BusinessName,Valid,Errors) 
				VALUES('#{record[0]}','#{record[1]}','#{record[2]}','#{record[3]}','#{record[4]}',
				#{valid},'#{errors}')"
	# insert record
	query.execute
	ensure
		# close insert statement
		query.close if query
end