require 'rake'
require File.expand_path("#{__dir__}/../../rakefile.rb")

MAX_TRIES = 2
$CURRENT_ATTEMPT = 0

Then (/^Image is (posted|not posted) to the server$/) do |flag|
  status = backdoor "isCalabashTLFImagePosted:", 'dummyParam'
  if status == "1"
    if flag == "posted"
      puts 'Image is posted to the server'
    else
      fail(msg ="Image is not posted to the server")
    end
  else
    if flag == "not posted"
      fail(msg ="Image is posted to the server")
    else
      puts 'Image is not posted to the server'
    end
  end
end

Then (/^posted json should have EOCoreSessionID in the json log$/) do
  status = backdoor "requestManualPost:", 'dummyParam'
  uri = URI("http://#$HOST_NAME:37265?json")

  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(req)

  #puts response.body
  res = response.body
  if res && res.length >= 2
    json = JSON.parse(res)

    h1 = json["sessions"]
    puts "h1 value: "
    h2 = h1[0]

    sessionId = h2["EOCoreSessionID"]

    if sessionId
      puts 'EOCoreSessionID found'
      puts sessionId
    else
      fail(msg ="EOCoreSessionID not found.")
    end
  else
    puts 'No logs.. '
  end
  puts "sleeping now -----"
  sleep(30)
end

def retryImageValidation
    puts "Retrying the validation for Image--------------"
    if !imageValidation
        fail(msg ="Posted json doesnot contain image element")
        else
        puts "Image element found"
    end
end

Then(/^posted json should have type 10 and contains image property$/) do
    if !imageValidation
        fail(msg ="Posted json doesn't contain image element.")
        else
        puts 'JSON image element found'
    end
end

def imageValidation
    uri = URI("http://#$HOST_NAME:37265?json")

    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(req)

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
                elemLayout = elem["layout"]
                if elemLayout["controls"]
                    control = elemLayout["controls"]
                    for con in control
                        if con["type"] == "UIView"
                            data = con["currState"]["data"]
                            for view in data
                                if view["type"] == "UIImageView"
                                    puts 'Image element found'
                                    boolFlag = true
                                end
                            end
                        end
                    end
                end
            end
        end

        if !boolFlag
            puts 'Attempting to retry the log retrieval1'
            if $CURRENT_ATTEMPT < MAX_TRIES
            puts 'Attempting to retry the log retrieval2'
            $CURRENT_ATTEMPT = $CURRENT_ATTEMPT + 1
            return retryImageValidation
            puts 'image property not found'
            end
        end
    end
    return boolFlag
end

def to_utf8(str)
  str = str.force_encoding('UTF-8')
  return str if str.valid_encoding?
  str.encode("UTF-8", 'binary', invalid: :replace, undef: :replace, replace: '')
end