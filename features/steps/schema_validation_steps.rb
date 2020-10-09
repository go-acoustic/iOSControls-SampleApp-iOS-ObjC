require 'rake'
require File.expand_path("#{__dir__}/../../rakefile.rb")
require 'json'

VALIDATION_MAX_TRIES = 2
$CURRENT_ATTEMPT = 0
$LAST_RESPONSE = nil
$CAN_RETRY = false

def get_data_from_server()

  puts "Requesting Server with host name: #$HOST_NAME"
  uri = URI("http://#$HOST_NAME:37265?json")

  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(req)

  #puts "Inside get_data_from_server"
  #puts response.body
  res = response.body

  if res && res.length >= 2
    messages = JSON.parse(res)
    #puts "Response from server: #{res}"
    $LAST_RESPONSE = messages
    return messages
  else
    puts 'No console log available.. sleeping for 30 seconds to try again later'
    if $CURRENT_ATTEMPT < VALIDATION_MAX_TRIES
      puts "#{$CURRENT_ATTEMPT} Attempt  retry the log"
      $CURRENT_ATTEMPT = $CURRENT_ATTEMPT + 1
      sleep(30)
      return get_data_from_server
    else
      $CURRENT_ATTEMPT = 0
      return nil
    end
  end
end

Then(/^posted json should match the client environment schema$/) do
  data = get_data_from_server
  if data.nil?
    fail(msg ="Data not received from server")
  else
    if !validate_json_clientEnvr(data)
      fail(msg ="Posted json doesn't match clientEnvr. Check logs for details")
    else
      puts 'JSON clientEnvr Validation successful'
    end
  end
end

Then(/^posted json should match the message type (1|2|3|4|5|6|7|8|9|10|11|12|13) schema$/) do |message_type|

  data = get_data_from_server
  if data.nil?
    if $LAST_RESPONSE.nil?
      fail(msg ="Data not received from server")
    else
      $CAN_RETRY = true
      if !validate_json_messageType($LAST_RESPONSE, Integer(message_type))
        fail(msg ="Posted json doesn't match schema type #{message_type}. Check logs for details")
      else
        puts "JSON Type #{message_type} Validation successful"
      end
      $CAN_RETRY = false
    end
  else
    $CAN_RETRY = false
    if !validate_json_messageType(data, Integer(message_type))
      fail(msg ="Posted json doesn't match schema type #{message_type}. Check logs for details")
    else
      puts "JSON Type #{message_type} Validation successful"
    end
  end
end

def retryValidation(msgType)
  puts "Retrying the validation for '#{msgType}'-------------"
  data = get_data_from_server
  if data.nil?
    fail(msg ="Data not received from server")
  else
    if !validate_json_messageType(data, Integer(msgType))
      fail(msg ="Posted json doesn't match schema type #{msgType}. Check logs for details")
    else
      puts "JSON Type #{msgType} Validation successful"
    end
  end
end

def validate_json_clientEnvr(json)
  schemaFile = File.expand_path(__dir__ + '/schema/schemaClientEnvr.json')
  #puts 'Validating schema from:  '
  #puts schemaFile

  h1 = json["sessions"]
  #puts "h1 value: "
  h2 = h1[0]

  puts 'printing clientEnvr elem --'
  cliEvn = h2["clientEnvironment"].to_json
  puts to_utf8(cliEvn)

  failures = JSON::Validator.fully_validate(schemaFile, h2["clientEnvironment"], :strict => true)

  if failures.count > 0
    puts 'Validation errors found'
    failures.each do |error|
      puts error
    end
    puts 'ERROR ! ERROR ! ERROR'
    return false
  end
  return true
end

def validate_json_messageType(json, messageType)

  if messageType < 10
    fileExt = '0' + messageType.to_s
  else
    fileExt = messageType.to_s
  end

  schemaFile = File.expand_path(__dir__ + '/schema/schemaType' + fileExt + '.json')
  #puts 'Validating schema from:  '
  #puts schemaFile

  puts "Inside validate_json_messageType"  #": #{json.to_json}"
  h1 = json["sessions"]
  h2 = h1[0]
  sessionStartTime = h2["startTime"]
  h3 = h2["messages"]

  boolFlag = false
  isElemFound = false
  for elem in h3
    msgOffset = elem["offset"]
    currentTime = Time.now.to_f * 1000
    puts 'Checking offset'
    if (sessionStartTime + msgOffset > currentTime) && msgOffset > 0
      puts "OffSet value is greater than current time: #{msgOffset}"
      #return false
    end

    if elem["type"] == messageType  # && sessionStartTime + msgOffset + 30 < currentTime
      failures = JSON::Validator.fully_validate(schemaFile, elem)

      temp = elem
      puts "printing elem of #{messageType} --"
      j_temp = temp.to_json
      puts to_utf8(j_temp)
      puts '*-------------------*'

      isElemFound = true

      $CURRENT_ATTEMPT = 0

      if failures.count > 0
        puts 'Validation errors found'
        failures.each do |error|
          puts error
        end
        puts 'ERROR ! ERROR ! ERROR'
        return false
      end

      if messageType == 1
        boolFlag = validate_messageType_1(temp)
      end

      if messageType == 4
        boolFlag = validate_messageType_4(temp)
      end

      if messageType == 10
        boolFlag = validate_messageType_10(temp)
      end

      if messageType == 11
        boolFlag = validate_messageType_11(temp)
      end

      boolFlag = true

      # if !boolFlag
      #   return boolFlag
      # end
    end
  end
  if !isElemFound && !$CAN_RETRY
    puts 'Attempting to retry the log retrieval1'
    if $CURRENT_ATTEMPT < VALIDATION_MAX_TRIES
      puts 'Attempting to retry the log retrieval2'
      sleep(20)
      $CURRENT_ATTEMPT = $CURRENT_ATTEMPT + 1
      return retryValidation(messageType)
    end
  end
  return boolFlag
end

def validate_messageType_4(elem)
  if elem["target"]["type"] == "UITextField" && elem["event"]["tlEvent"] == "textChange"
    puts 'Text Change.. Checking dwell and visitedCount properties'
    if !elem["target"].key?("dwell") && elem["target"].key?("visitedCount")
      puts 'Does not contain dwell property for textField'
      return false
    end
  end

  if elem["target"]["position"].key?("relXY")
    relXY = elem["target"]["position"]["relXY"]
    relX = Float(relXY[0..3])
    relY = Float(relXY[5..8])
    puts "relX:#{relX}, relY:#{relY}"
    unless relX.between?(0.0, 1.0) && relY.between?(0.0, 1.0)
      puts 'Message type 4 property relXY validation failed'
      return false
    end
  end
  return true
end

def validate_messageType_1(elem)
  mobileState = elem["mobileState"]
  if (mobileState["battery"] < -1)  && (mobileState["battery"] > 100)
    puts 'Message type 1 property battery validation failed'
    return false
  end

  networkReachability = mobileState["networkReachability"]
  if !(["Unknown", "NotReachable", "ReachableViaWIFI", "ReachableViaWWAN"].include? networkReachability)
    puts 'Message type 1 property networkReachability validation failed'
     return false
  end
  pageOrientation = mobileState["pageOrientation"]
  if !([0, 90, 180, -90].include? pageOrientation)
    puts 'Message type 1 property pageOrientation validation failed'
     return false
  end
  orientation = mobileState["orientation"]
  if !([0, 90, 180, -90].include? orientation)
    puts 'Message type 1 property orientation validation failed'
     return false
  end
  return true
end

def validate_messageType_10(elem)
  orientation = elem["orientation"]
  if !([0, 90, 180, -90].include? orientation)
    puts 'Message type 10 property orientation validation failed'
    return false
  end
  return true
end

def validate_messageType_11(elem)
  touches = elem["touches"]
  len = touches.length
  for i in 0..len - 1
    #puts "Inside outerloop: #{i}"
    #puts "Touches length for i element: #{touches[i].length - 1}"
    outerloopLen = touches[i].length - 1
    for j in 0..outerloopLen
      #puts "Inside innerLoop: #{j}"
      relXY = touches[i][j]["control"]["position"]["relXY"]
      relX = Float(relXY[0..3])
      relY = Float(relXY[5..8])
      puts "relX:#{relX}, relY:#{relY}"
      unless relX.between?(0.0, 1.0) && relY.between?(0.0, 1.0)
        puts 'Message type 11 property relXY validation failed'
        return false
      end
    end
  end
  return true
end

def to_utf8(str)
  str = str.force_encoding('UTF-8')
  return str if str.valid_encoding?
  str.encode("UTF-8", 'binary', invalid: :replace, undef: :replace, replace: '')
end
