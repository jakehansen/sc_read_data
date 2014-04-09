require 'sqlite3'
require 'active_support/inflector'

def display_data
	begin
		# open database connection
		db = SQLite3::Database.open "lib/db/data.db"

		# display data for each of the record types
		display_records db, "business", false
		display_records db, "user", false
		display_records db, "business", true
		display_records db, "user", true

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

def display_records (db, model, malformed)
	models = model.pluralize
	# display the heading for the follwing data
	heading = malformed ? "Malformed " + model.capitalize + " Records" : models.capitalize
	STDOUT.puts "#{heading}:"
	STDOUT.puts ""

	# determine which database field the results should be ordered by
	order_field = (model == "business") ? "Name" : "BusinessName"
	# determine whether to search valid or invalid results
	valid = malformed ? 0 : 1
	# select the records from the database
	records = db.execute "SELECT * FROM #{models} WHERE Valid = #{valid} ORDER BY #{order_field} ASC"
	# display the details of each result
	display_details db, records, model, malformed
end

def display_details (db, records, model, malformed)
	# print the details for each business record in the collection
	if model == "business"
		records.each do |record|
			STDOUT.puts "Name: #{record[1]}"
			STDOUT.puts "Address: #{record[2]}"
			STDOUT.puts "City: #{record[3]}"
			STDOUT.puts "State: #{record[4]}"
			STDOUT.puts "Zip: #{record[5]}"
			STDOUT.puts "Phone: #{record[6]}"
			STDOUT.puts "Fax: #{record[7]}"
			STDOUT.puts "Email: #{record[8]}"
			if malformed
				error = error_message record[10]
				STDOUT.puts "Errors: #{error}"
			else
				user_count = db.execute "SELECT COUNT(DISTINCT Email) FROM users WHERE Valid = 1 AND BusinessName = '#{record[1]}'"
				STDOUT.puts "Unique Users: #{user_count[0][0]}"
			end
			STDOUT.puts ""
		end
	# print the details for each user record in the collection
	elsif model == "user"
		business = ""
		records.each do |record|
			unless malformed
				if business != record[5]
					business = record[5]
					STDOUT.puts "#{business} Users:"
					STDOUT.puts ""
				end
			end
			STDOUT.puts "Name: #{record[1]}"
			STDOUT.puts "Email: #{record[2]}"
			STDOUT.puts "Phone: #{record[3]}"
			STDOUT.puts "Title: #{record[4]}"
			STDOUT.puts "Business Name: #{record[5]}"
			if malformed
				error = error_message record[7]
				STDOUT.puts "Errors: #{error}"
			end
			STDOUT.puts ""
		end
	end
end

# convert the error keywords into readable phrases
def error_message (errors)
	message = ""
	error_array = errors.split

	error_array.each do |error|
		case error
		when "name"
			message += "Invalid Name \n"
		when "email"
			message += "Invalid Email \n"
		when "dup"
			message += "Duplicate Name \n"
		when "bName"
			message += "Invalid Business Name \n"
		end
	end
	
	return message
end