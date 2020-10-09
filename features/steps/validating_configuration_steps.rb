require 'rake'
require File.expand_path("#{__dir__}/../../rakefile.rb")

CONFIG_MAX_TRIES = 2
$CURRENT_ATTEMPT = 0

Then (/^TLF is (enabled|disabled)$/) do |flag|
  status = backdoor "isCalabashTLFEnalbed:", 'dummyParam'
  if status == "1"
    if flag == "enabled"
      puts 'TeaLeaf framework is enabled'
    else
      fail(msg ="-- Tealeaf framework is enabled --")
    end
  else
    if flag == "enabled"
      fail(msg ="Tealeaf framework is disabled")
    else
      puts 'TeaLeaf framework is disabled'
    end
  end
end

Then (/^posted json (should|should not) have type 11 and fromWeb property is set to (true|false)$/) do |flag1, flag2|
  if !validate_layout(flag1, flag2)
      fail(msg ="JSON validation failed.")
  else
      puts 'JSON validation success'
  end
end

def validate_layout(flag1, flag2)
  uri = URI("http://#$HOST_NAME:37265?json")

  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(req)
  #puts response.body
  res = response.body

  boolFlag = true

  if res && res.length >= 2
    json = JSON.parse(res)
    h1 = json["sessions"]
    h2 = h1[0]
    h3 = h2["messages"]

    res1 = false
    res2 = false

    for elem in h3
      if elem['fromWeb']
        #puts 'Inside fromWeb is true block'
        res2 = true
      end

      if elem["type"] == 11
        res1 = true
      end
    end

    if flag1 == "should"
      #puts 'Inside flag1 is true block'
      if !res1
        boolFlag = false
        #fail(msg ="Type 11 not found")
      end
    else #if flag2 == "should not"
      #puts 'Inside flag1 is false block'
      if res1
        boolFlag = false
        #fail(msg ="Type 11 found")
      end
    end

    if flag2 == "true"
      #puts 'Inside falg2 is true block'
      if !res2
        #fail(msg ="fromWeb property is false")
        boolFlag = false
      end
    else
      #puts 'Inside flag2 is false block'
      if res2
        #fail(msg ="fromWeb property is true")
        boolFlag = false
      end
    end

  else
    puts 'No logs.. '
    #fail(msg ="json log not found.")
    boolFlag = false
  end

  if !boolFlag
    puts 'Attempting to retry the log retrieval1'
    if $CURRENT_ATTEMPT < CONFIG_MAX_TRIES
      puts 'Attempting to retry the log retrieval2'
      sleep(30)
      $CURRENT_ATTEMPT = $CURRENT_ATTEMPT + 1
      return retryLayoutValidation(flag1, flag2)
    end
  end
  $CURRENT_ATTEMPT = 0
  return boolFlag
end

def retryLayoutValidation(flag1, flag2)
    puts "Retrying the layout validation--------------"
    if !validate_layout(flag1, flag2)
        fail(msg ="Posted json validation failed")
        else
        puts "Posted json validation success"
    end
end

def retryMaskingValidation(entryType, logLevel)
    puts "Retrying the masking validation--------------"
    if !validate_text_masking(entryType, logLevel)
        fail(msg ="Posted json doesnot mask the content")
        else
        puts "content is masking based on logging level"
    end
end

Then(/^textField is (secure|not secure) and logging level is (0|1|2|3|4)$/) do |flag1, flag2|
    if !validate_text_masking(flag1, Integer(flag2))
        fail(msg ="Posted json doesnot mask the content.")
        else
        puts 'content is masking based on logging level'
    end
end

def validate_text_masking(entryType, logLevel)

  uri = URI("http://#$HOST_NAME:37265?json")

  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(req)

  res = response.body
  #puts 'Response for text Masking'
  #puts res

  boolFlag = false
  if res && res.length >= 2
      json = JSON.parse(res)

      h1 = json["sessions"]
      h2 = h1[0]
      h3 = h2["messages"]

      #puts 'JSON Log for text Masking Validation'
      #puts h3

      boolFlag = false

      for elem in h3
        if elem["type"] == 4
          puts 'Type 4 found for text masking'
          puts to_utf8(elem.to_json)
          puts '----'
          #if elem["event"]["tlEvent"]
          target = elem["target"]
          #puts target

          if target["currState"]
            currState = target["currState"]
            regExStatus = false
            if currState["text"]
                if logLevel == 0
                  if (currState["text"] =~ /[a-zA-Z0-9]/)
                    regExStatus = false
                  end
                elsif logLevel == 1
                  if (currState["text"] != "")
                    regExStatus = true
                  end
                elsif logLevel == 2
                  if (currState["text"] =~ /[a-zA-Z0-8&&[^X]]/)
                    regExStatus = true
                  end
                elsif logLevel == 3
                  if (currState["text"] =~ /[a-zA-Z0-8&&[^xX9]]/)
                    regExStatus = true
                  end
                elsif logLevel == 4
                  if (currState["text"] =~ /[a-zA-Z0-9&&[^Y]]/)
                    regExStatus = true
                  end
                end

                puts 'Text masking log level is set as 3'
                puts to_utf8(currState.to_json)
                #puts currState["text"]
                if (regExStatus)
                    puts 'RegEx matched..'
                    if entryType == "secure"
                      fail(msg ="Posted json doesnot mask the content.")
                    else
                      puts 'content is masked based on logging level'
                      boolFlag = true
                    end
                else
                     puts 'RegEx not matched..'
                     if entryType == "secure"
                       puts 'content is masking based on logging level'
                       boolFlag = true
                     else
                       fail(msg ="Posted json doesnot mask the content.")
                     end
                end
            end
        end
       end
     end
   end

  if !boolFlag
    puts 'Attempting to retry the log retrieval1'
    if $CURRENT_ATTEMPT < CONFIG_MAX_TRIES
      puts 'Attempting to retry the log retrieval2'
      sleep(30)
      $CURRENT_ATTEMPT = $CURRENT_ATTEMPT + 1
      return retryMaskingValidation(entryType, logLevel)
    end
  end
  $CURRENT_ATTEMPT = 0
  return boolFlag
end

def to_utf8(str)
  str = str.force_encoding('UTF-8')
  return str if str.valid_encoding?
  str.encode("UTF-8", 'binary', invalid: :replace, undef: :replace, replace: '')
end