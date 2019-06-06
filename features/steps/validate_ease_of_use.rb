require 'rake'
require File.expand_path("#{__dir__}/../../rakefile.rb")

EASE_OF_USE_MAX_TRIES = 2
$CURRENT_ATTEMPT = 0

def retryElemValidation(type)
    puts "Retrying the validation for Custom Element ID--------------"
    if !elemValidation(type)
        fail(msg ="Posted json doesnot contain #{type} element")
    else
        puts "#{type} Validation successful"
    end
end

Then(/^posted json should have message type 10 and contains custom id for textView$/) do
    if !elemValidation("")
        fail(msg ="Posted json doesn't match clientEnvr. Check logs for details")
    else
        puts 'Custom element found'
    end
end

Then(/^posted json should have message type 10 and contains "Banana" under layout$/) do
    if !elemValidation("Banana")
        fail(msg ="Posted json doesn't match clientEnvr. Check logs for details")
    else
        puts 'banana element found'
    end
end

def elemValidation(elemType)
    uri = URI("http://#$HOST_NAME:37265?json")

    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(req)
    puts 'New Response --------'
    puts response.body
    res = response.body

    boolFlag = false
    if res && res.length >= 2
        json = JSON.parse(res)
        h1 = json["sessions"]
        h2 = h1[0]
        h3 = h2["messages"]

        for elem in h3

            if elem["type"] == 10

                $CURRENT_ATTEMPT = 0

                layout = elem["layout"]
                puts 'Layout element'
                puts layout.to_json
                if elemType == "Banana"
                  if layout["name"] == "Banana"
                    puts 'Banana name found'
                    boolFlag = true
                  end
                else
                    if layout["controls"]
                        control = layout["controls"]
                        for con in control
                            if con["type"] == "UIView"
                                data = con["currState"]["data"]
                                for view in data
                                    if view["type"] == "UITextField"
                                        if view["mid"]
                                            puts 'Mid found'
                                            puts view['mid']
                                            boolFlag = true
                                        end
                                    end
                                end
                            end
                        end
                     end
                 end
            end
        end
      end
      if !boolFlag
          puts 'Attempting to retry the log retrieval1'
          if $CURRENT_ATTEMPT < EASE_OF_USE_MAX_TRIES
              puts 'Attempting to retry the log retrieval2'
              $CURRENT_ATTEMPT = $CURRENT_ATTEMPT + 1
              sleep(30)
              return retryElemValidation(elemType)
              #puts 'Mid property not found'
          end
      end
      return boolFlag
end

def to_utf8(str)
  str = str.force_encoding('UTF-8')
  return str if str.valid_encoding?
  str.encode("UTF-8", 'binary', invalid: :replace, undef: :replace, replace: '')
end