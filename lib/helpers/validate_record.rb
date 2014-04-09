require 'sqlite3'

def is_record_valid (db, record, model)
	if model == "business"
		# determine if the business record has any errors
		errors = validate_business db, record
	elsif model == "user"
		# determine if the user record has any errors
		errors = validate_user db, record
	end

	return errors
end

def validate_business (db, record)
	errors = ""
	# if the business name is empty, include the name error
	if record[0].nil? 
		errors += "name "
	else 
		# if the business name is already used by a valid record, include the dup error
		duplicate = name_used db, record[0]
		if duplicate > 0 then errors += "dup " end
	end
	# if the email address is not formatted properly, include the email error
	email_valid = valid_email record[7]
	if email_valid.nil? then errors += "email " end
	return errors
end

def validate_user (db, record)
	errors = ""
	# if the user name is empty, include the name error
	if record[0].nil? then errors += "name " end
	# if the email address is not formatted properly, include the email error
	email_valid = valid_email record[1]
	if email_valid.nil? 
		errors += "email "
	else
		# if the email address is already used by a valid record, include the dup error
		duplicate = email_used db, record[1]
		if duplicate > 0 then errors += "dup " end
	end
	# if the business name is empty, include the bName error
	if record[4].nil? then errors += "bName" end
	return errors
end

# validate email addresses by matching them with the regular expression
def valid_email (string)
	res = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i =~ string
	return res
end

# check businesses table for a valid record using the specified name
def name_used (db, name)
	count = db.execute "SELECT COUNT(Name) FROM businesses WHERE Name = '#{name}' AND Valid = 1"
	return count[0][0]
end

# check the users table for a valid record using the specified email address
def email_used (db, email)
	count = db.execute "SELECT COUNT(Email) FROM users WHERE Email = '#{email}' AND Valid = 1"
	return count[0][0]
end