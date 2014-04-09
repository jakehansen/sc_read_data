Feature: Read CSV data
  I want a simple way to parse csv data and 
  subsequently view the results.

  Scenario: Basic UI
    When I get help for "sc_read_data"
    Then the exit status should be 0
    And the banner should be present
    And the banner should include the version
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
      |--results|
      |-r|
    And the banner should document that this app takes no arguments

  # I was working on writing acceptance tests for
  # When I run `sc_read_data`
  # And
  # When I run `sc_read_data -r`
  # Configuring the tests to run on a test database is going to take more time than I have left
  # I am interested to learn how to set up an acceptance test for these scenarios