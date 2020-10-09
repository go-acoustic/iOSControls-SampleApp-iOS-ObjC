require 'calabash-cucumber/uia.rb'
#require 'calabash-cucumber/actions/instruments_actions.rb'
require 'calabash-cucumber/rotation_helpers.rb'
require File.expand_path("#{__dir__}/../../helper/test_server.rb")



FIRSTSTEPS_STEP_PAUSE = 10
FIRSTSTEPS_WAIT_TIMEOUT = 10

Given (/^I am on the Welcome Screen$/) do
  # server = TestServer
  # puts TestServer.room_count
  element_exists("view")
  status = backdoor "requestManualPost:", 'dummyParam'
  # sleep(45)
  # puts '10)sleeping now ... '
  # sleep(45)
  # puts TestServer.getBody
  # sleep(STEP_PAUSE)
end

Then (/^I should be on Products screen$/) do
  wait_for_text("Shop", timeout: $FIRSTSTEPS_WAIT_TIMEOUT)
end

Then (/^I (?:press|touch) the "([^\"]*)" alert button$/) do |mark|
	touch("UILabel marked:'#{mark}'")
	sleep(FIRSTSTEPS_STEP_PAUSE)
end

And(/^I touch the spinner$/) do
  sleep(FIRSTSTEPS_STEP_PAUSE)
  touch('UITableViewCell index:17')
  # wait_for_element_exists('android.support.v7.widget.AppCompatCheckedTextView', timeout: TIMEOUT_VALUE)
  # # touch("AppCompatCheckedTextView marked:'Radio, ProgressBars and RatingBar'")
  # # touch("AppCompatRadioButton id:'radio2'")
  # # puts 'Retrieve type Type4 Json messages ===> '
  # # puts backdoor('getJsonStringByType', '4')
end
