# Requiring this file will import Calabash and the Calabash predefined Steps.
require 'calabash-cucumber/cucumber'
require 'fileutils'
require 'net/http'
#require File.expand_path("#{__dir__}/../step_definitions/tlf_json_parser")
#require File.expand_path("#{__dir__}/../../../../BuildTools/SharedCucumberHelpers/test_server.rb")
# require File.expand_path("#{__dir__}/../step_definitions/tlf_json_parser.rb")
require File.expand_path("#{__dir__}/../../helper/test_server.rb")
#require File.expand_path("#{__dir__}/test_server.rb")
#require File.expand_path("#{__dir__}/../../../../BuildTools/SharedCucumberHelpers/helpers/tlf_json_parser")
#require File.expand_path("#{__dir__}/../../../../BuildTools/SharedCucumberHelpers/test_server.rb")

#Reset the simulator and derived data
system('killall "iOS Simulator"')
system('killall "Simulator"')
system('killall "com.apple.CoreSimulator.CoreSimulatorService"')
derived_data_folder = File.expand_path('~/Library/Developer/Xcode/DerivedData')
app_folders = Dir.entries(derived_data_folder).select{ |i| i[/Pier39-.*$/] }

app_folders.each do |folder|
  FileUtils.rm_r "#{derived_data_folder}/#{folder}"
end

existing_apps = Dir.glob(File.expand_path('~/Library/Developer/CoreSimulator/Devices/**/Pier39-cal.app'))
existing_apps.each do |app|
  FileUtils.rm_r File.dirname(app)
end

project_path = File.expand_path('./iOSAutomationTestApp.xcodeproj')
device = 'iPhone 6'
sdk = 'iphonesimulator'

system("xcodebuild -project '#{project_path}' -scheme 'iOSAutomationTestApp-cal' -destination=build -destination name='#{device}' -configuration Debug -sdk #{sdk} ONLY_ACTIVE_ARCH=NO clean build | xcpretty -cs --no-utf && exit ${PIPESTATUS[0]}")

pid = Process.fork do
  TestServer.start
  # puts 'sleeping now ... '
  # puts 'process number... '
  # puts pid
  # sleep(45)
  # puts "!!!!THIS IS THE BODEEEEY!!!!!!"
  # puts TestServer.getBody
end
puts "Test server background pid: #{pid}"


at_exit do
  Process.kill(3, pid)
end