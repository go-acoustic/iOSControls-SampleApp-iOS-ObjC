require 'calabash-cucumber/uia.rb'
#require 'calabash-cucumber/actions/instruments_actions.rb'
require 'calabash-cucumber/rotation_helpers.rb'
require File.expand_path("#{__dir__}/../../helper/test_server.rb")

Then (/^I rotate home button to (left|right|up|down)$/) do |direction|
	puts "- - - - -hello world"
	stringBody = StringIO.new(TestServer.getBody)
	gz = Zlib::GzipReader.new( stringBody )
	page = gz.read()
	puts page
	puts '- - - - -hello world'
	rotate_home_button_to(direction)
end

Then (/^I rotate device to (left|right|up|down)$/) do |direction|

  # puts 'sleeping now ... '
  # sleep(45)
  # puts 'rotating'
  rotate(direction)
  sleep(15)
	status = backdoor "requestManualPost:", 'dummyParam'
	#puts 'sleeping now ... '
	sleep(5)
end
