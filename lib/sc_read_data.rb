require 'sc_read_data/version'
require 'helpers/database_init'
require 'helpers/read_csv'
require 'helpers/display_stats'
require 'helpers/display_data'

module ScReadData
	# function that is called when the application is run with no options
	def read_data
		db_init
		read_csv_data
	end
	module_function :read_data

	# function that is called when the application is run with the -r or --results function
	def display_results
		display_stats
		display_data
	end
	module_function :display_results
end
