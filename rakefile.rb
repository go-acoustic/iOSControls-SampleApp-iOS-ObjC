require './ConfigureTLFResource.rb'

$HOST_NAME = ENV['host_name'] || 'localhost'

desc "Example of task with parameters and prerequisites"
task :sample do

  puts "Host Name: #$HOST_NAME"

  obj = ConfigureTLFResource.new()
  #obj.setPostMessageURL "http://#$HOST_NAME:37265"

  obj.setManualPost
  sh('bundle exec cucumber --tags @type1')

  # bundle = "EXPORT BUNDLE_ID='com.IBM.iOSControlsApp'"
  # endpoint = "EXPORT DEVICE_ENDPOINT='http://#$HOST_NAME:37265'"
  # udid = "EXPORT DEVICE_TARGET='4d1e8093e504255e6d9737e49f8e0302d5669dba'"
  # sh(bundle)
  # sh(endpoint)
  # sh(udid)

  #sh('export DEVICE_TARGET=4d1e8093e504255e6d9737e49f8e0302d5669dba')   #4869e9de19bd3e3add555ba3a8e1baa84c28449b')
  #sh('export BUNDLE_ID=com.IBM.iOSControlsApp')
  #sh('export DEVICE_ENDPOINT=http://172.20.10.4:37265')
end

desc "Task all runs all automation test cases"
task :allTests do

  url1 = ENV['reachableKillSwitchUrl']
  url2 = ENV['unReachableKillSwitchUrl']

  if !url1
    puts 'reachablekillSwitchUrl not set.. Using default one: http://sandp.devlab.ibm.com/mobile/KillSwitch1.htm'
    url1 = 'http://sandp.devlab.ibm.com/mobile/KillSwitch1.htm'
  end

  if !url2
    puts 'unReachableKillSwitchUrl not set.. Using default one: http://sandp.devlab.ibm.com/mobile/KillSwitch0.htm'
    url2 = 'http://sandp.devlab.ibm.com/mobile/KillSwitch0.htm'
  end

  obj = ConfigureTLFResource.new()

  puts "Host Name: #$HOST_NAME"
  obj.setPostMessageURL "http://#$HOST_NAME:37265"
  obj.setManualPost

  sh('bundle exec cucumber --tags @type1 --format json --out JsonReports/1.json; true')
  sh('bundle exec cucumber --tags @type2 --format json --out JsonReports/2.json; true')
  sh('bundle exec cucumber --tags @type4 --format json --out JsonReports/3.json; true')
  sh('bundle exec cucumber --tags @type1145 --format json --out JsonReports/4.json; true')
  sh('bundle exec cucumber --tags @type10 --format json --out JsonReports/5.json; true')
  sh('bundle exec cucumber --tags @type13 --format json --out JsonReports/6.json; true')

  obj.enableIP
  sh('bundle exec cucumber --tags @ipCapture --format json --out JsonReports/7.json; true')
  obj.maskIP
  sh('bundle exec cucumber --tags @ipMasking --format json --out JsonReports/8.json; true')
  obj.enableIP

  obj.enableImageData
  sh('bundle exec cucumber --tags @imageLogging --format json --out JsonReports/9.json; true')
  obj.disableImageData

  obj.setPostMessageURL ''
  sh('bundle exec cucumber --tags @UnresponsiveTarget --format json --out JsonReports/10.json; true')
  obj.setPostMessageURL 'http://localhost:37265'

  obj.setSessionizationCookieName 'TLTSID'
  sh('bundle exec cucumber --tags @Sessionization --format json --out JsonReports/11.json; true')

  #sh('cucumber --tags @CapturingLostHits1; true')
  #sh('cucumber --tags @CapturingLostHits2; true')

  obj.appendMapId("[w,0],[v,0],[v,0],[v,0],[v,0],[ta,1]","customTextView")
  sh('bundle exec cucumber --tags @AppendMapIds --format json --out Jsonreports/12.json; true')

  obj.addAutoLayoutElement("TextBtnViewController", {"do" => true, "screenViewName" => "Banana", "delay" => 0, "takeScreenShot" => false})
  sh('bundle exec cucumber --tags @AutoLayout10 --format json --out JsonReports/13.json; true')

  obj.enableKillSwitch
  obj.setKillSwitchURL(url1)
  sh('bundle exec cucumber --tags @killSwitch1 --format json --out JsonReports/14.json; true')
  obj.setKillSwitchURL(url2)
  sh('bundle exec cucumber --tags @killSwitch2 --format json --out JsonReports/15.json; true')
  obj.disableKillSwitch

  obj.disableGestureDetector
  obj.disableNativeGestureCaptureOnWebView
  sh('bundle exec cucumber --tags @logLayout1 --format json --out JsonReports/16.json; true')

  obj.disableNativeGestureCaptureOnWebView
  obj.enableGestureDetector
  sh('bundle exec cucumber --tags @logLayout2 --format json --out JsonReports/17.json; true')

  #obj.enableGestureDetector
  #obj.enableNativeGestureCaptureOnWebView
  #sh('cucumber --tags @logLayout3; true')

  obj.setCustomMaskingLevel
  sh('bundle exec cucumber --tags @TextFieldMasking --format json --out JsonReports/18.json; true')

  sh('bundle exec cucumber --tags @Gesture1 --format json --out JsonReports/19.json; true')
  #sh('cucumber --tags @Gesture2; true')

  puts "------ Testing completed -----"

  sh('node ReportGenerator.js')

end

desc "Task will do preset up for tests1"
task :pretask1 do

  url1 = ENV['reachableKillSwitchUrl']
  url2 = ENV['unReachableKillSwitchUrl']

  if !url1
    puts 'reachablekillSwitchUrl not set.. Using default one: http://sandp.devlab.ibm.com/mobile/KillSwitch1.htm'
    url1 = 'http://sandp.devlab.ibm.com/mobile/KillSwitch1.htm'
  end

  if !url2
    puts 'unReachableKillSwitchUrl not set.. Using default one: http://sandp.devlab.ibm.com/mobile/KillSwitch0.htm'
    url2 = 'http://sandp.devlab.ibm.com/mobile/KillSwitch0.htm'
  end

  obj = ConfigureTLFResource.new()

  obj.setBundleIdentifier "com.IBM.iOSControlsApp"

  puts "Host Name: #$HOST_NAME"
  obj.setPostMessageURL "http://#$HOST_NAME:37265"
  obj.enableIP
  obj.enableImageData
  obj.setSessionizationCookieName 'TLTSID'
  obj.appendMapId("[w,0],[v,0],[v,0],[v,0],[v,0],[t,0]","customTextField_Peggy")
  obj.addAutoLayoutElement("TextBtnViewController", {"do" => true, "screenViewName" => "Banana", "delay" => 0, "takeScreenShot" => false})
  obj.disableNativeGestureCaptureOnWebView
  obj.enableGestureDetector
  obj.setSecureTextFieldMaskingLevel '3'
  obj.enableKillSwitch
  obj.setKillSwitchURL(url1)
  obj.setManualPost

end

desc "Task will do preset up for tests2"
task :pretask2 do

  obj = ConfigureTLFResource.new()

  obj.setBundleIdentifier "com.IBM.iOSControlsApp1"

  puts "Host Name: #$HOST_NAME"
  obj.setPostMessageURL "http://#$HOST_NAME:37265"
  obj.maskIP
  obj.disableGestureDetector
  obj.disableNativeGestureCaptureOnWebView

end

desc "Task runs automation test cases on first build identifier app"
task :tests1 do
  sh('bundle exec cucumber --tags @type1 --format json --out DevReports/1.json; true')
  sh('bundle exec cucumber --tags @type2 --format json --out DevReports/2.json; true')
  sh('bundle exec cucumber --tags @type4 --format json --out DevReports/3.json; true')
  sh('bundle exec cucumber --tags @type1145 --format json --out DevReports/4.json; true')
  sh('bundle exec cucumber --tags @type10 --format json --out DevReports/5.json; true')
  sh('bundle exec cucumber --tags @type13 --format json --out DevReports/6.json; true')

  sh('bundle exec cucumber --tags @ipCapture --format json --out DevReports/7.json; true')
  sh('bundle exec cucumber --tags @killSwitch1 --format json --out DevReports/8.json; true')
  sh('bundle exec cucumber --tags @imageLogging --format json --out DevReports/9.json; true')
  sh('bundle exec cucumber --tags @Sessionization --format json --out DevReports/10.json; true')
  sh('bundle exec cucumber --tags @AppendMapIds --format json --out DevReports/11.json; true')
  sh('bundle exec cucumber --tags @AutoLayout10 --format json --out DevReports/12.json; true')
  sh('bundle exec cucumber --tags @logLayout2 --format json --out DevReports/13.json; true')
  sh('bundle exec cucumber --tags @TextFieldMasking --format json --out DevReports/14.json; true')

end

desc "Task runs automation test cases on second build identifier app"
task :tests2 do
  sh('bundle exec cucumber --tags @ipMasking --format json --out DevReports/15.json; true')
  sh('bundle exec cucumber --tags @logLayout1 --format json --out DevReports/16.json; true')
  sh('node ReportGenerator.js')
end