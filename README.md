# ScReadData

ScReadData is a command line application for parsing business and user csv data into a readable format.

## Installation

THEORETICALLY (if this gem was hosted on RubyGems)
Add this line to your application's Gemfile:

    gem 'sc_read_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sc_read_data

REALITY
For development make sure that you run the app with bundle exec:

	$ bundle exec bin/sc_read_data [options]

## Usage

ScReadData provides two services:

1. Reading CSV Data
The default behavior of the app is to read CSV data

	$ bundle exec bin/sc_read_data

2. Displaying Data Results
Use the -r, --results option to view the results

	$ bundle exec bin/sc_read_data --results