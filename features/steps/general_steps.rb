require 'rubygems'
require 'json'
require 'json-schema'
require 'rake'
require File.expand_path("#{__dir__}/../../helper/test_server.rb")
require File.expand_path("#{__dir__}/../../rakefile.rb")

#STEP_PAUSE = 5
#WAIT_TIMEOUT = 5

Given(/^I disable TLF framework$/) do
  touch("view marked:'killSwitch'")
  puts "sleeping now -----"
  sleep(30)
end

Then(/^I don't see any logs$/) do
  status = backdoor "requestManualPost:", 'dummyParam'
  uri = URI("http://#$HOST_NAME:37265?json")

  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(req)

  #puts "Inside get_data_from_server"
  #puts response.body
  res = response.body
  if res && res.length >= 2
    fail('There are logs.. Framework is still enabled')
  else
    puts 'No logs.. '
  end
  puts "sleeping now -----"
  sleep(30)
end

Given(/^I enable TLF framework$/) do
  touch("view marked:'killSwitch'")
  puts "sleeping now -----"
  sleep(30)
end

Then(/^posted json should (contain|not contain) ip as part of client Environment$/) do |flag|
  status = backdoor "requestManualPost:", 'dummyParam'
  if !validate_ip(flag)
    fail(msg ="IP validation failed")
  else
    puts "ip is #{flag} in the json log"
  end
end

def validate_ip(flag)
  uri = URI("http://#$HOST_NAME:37265?json")

  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(req)

  puts to_utf8(response.body)
  res = response.body
  if res && res.length >= 2
    json = JSON.parse(res)
    h1 = json["sessions"]
    h2 = h1[0]
    h3 = h2["messages"]

    boolFlag = false
    type1Flag = false
    for elem in h3
      if elem["type"] == 1
        type1Flag = true
        mState = elem["mobileState"]
        puts 'Type 1 found'
        #puts mState
        ip = mState["ip"]
        if ip
          #puts 'IP of the device---'
          #puts mState["ip"]
          if ip != "N/A"
            boolFlag = true
          end
        end
      end
    end

    if !boolFlag
      if !type1Flag
        puts 'Type 1 not found'
        sleep(20)
        validate_ip(flag)
      else
        if flag == "contain"
          return false
        else
          puts 'Case succeeded.. ip is masked under client environment'
          return true
        end
      end
    else
      if flag == "contain"
        puts 'Case succeeded.. ip is under client environment'
        return true
      else
        return false
      end
    end
  else
    puts 'No logs.. '
    puts 'Attempting to retry the log retrieval1'
    if $CURRENT_ATTEMPT < MAX_TRIES
      puts 'Attempting to retry the log retrieval2'
      sleep(30)
      $CURRENT_ATTEMPT = $CURRENT_ATTEMPT + 1
      return validate_ip(flag)
    else
      return false
    end
  end
  $CURRENT_ATTEMPT = 0
  puts "sleeping now -----"
  sleep(30)
end

Given(/^I close the app$/) do
  calabash_exit
end

def to_utf8(str)
  str = str.force_encoding('UTF-8')
  return str if str.valid_encoding?
  str.encode("UTF-8", 'binary', invalid: :replace, undef: :replace, replace: '')
end

Given(/^the user is on the ([^"]*) screen$/) do |screen|
  step("I touch \"#{screen}\"")
end
