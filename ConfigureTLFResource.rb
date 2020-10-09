require 'Plist'
require 'json'

class ConfigureTLFResource
  KILL_SWITCH_VALID_URL   = "http://sandp.devlab.ibm.com/mobile/KillSwitch1.htm"
  KILL_SWITCH_INVALID_URL = "http://sandp.devlab.ibm.com/mobile/KillSwitch0.htm"
  ADV_CONFIG_JSON = '../LibraryBuilds/Tealeaf/Debug/TLFResources.bundle/TealeafAdvancedConfig.json'
  LAYOUT_CONFIG_JSON = '../LibraryBuilds/Tealeaf/Debug/TLFResources.bundle/TealeafLayoutConfig.json'
  PLIST_LOCATION = "../LibraryBuilds/Tealeaf/Debug/TLFResources.bundle/TealeafBasicConfig.plist"
  APP_PLIST_LOCATION = "./iOSAutomationTestApp/Info.plist"
  EO_CORE_CONFIG = "../LibraryBuilds/EOCore/Debug/EOCoreSettings.bundle/EOCoreBasicConfig.plist"

  def enableKillSwitch
    result = Plist::parse_xml(PLIST_LOCATION)
    puts "killSwitch status: #{result['KillSwitchEnabled']}"
    result['KillSwitchEnabled'] = true
    result['KillSwitchUrl'] = KILL_SWITCH_VALID_URL
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def disableKillSwitch
    result = Plist::parse_xml(PLIST_LOCATION)
    puts "killSwitch status: #{result['KillSwitchEnabled']}"
    result['KillSwitchEnabled'] = false
    result['KillSwitchUrl'] = KILL_SWITCH_INVALID_URL
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def setKillSwitchURL(url)
    result = Plist::parse_xml(PLIST_LOCATION)
    puts "Current killSwitch url: #{result['KillSwitchUrl']}"
    result['KillSwitchUrl'] = url
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def setBundleIdentifier(name)
    result = Plist::parse_xml(APP_PLIST_LOCATION)
    puts "Result: #{result}"
    puts "Current bundle id: #{result['CFBundleIdentifier']}"
    result['CFBundleIdentifier'] = name
    result.to_plist
    Plist::Emit.save_plist(result, APP_PLIST_LOCATION)
  end

  def enableImageData
    result = Plist::parse_xml(PLIST_LOCATION)
    result['GetImageDataOnScreenLayout'] = true
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def disableImageData
    result = Plist::parse_xml(PLIST_LOCATION)
    result['GetImageDataOnScreenLayout'] = false
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def setSessionizationCookieName(name)
    result = Plist::parse_xml(PLIST_LOCATION)
    result['SessionizationCookieName'] = name
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def enableGeolocation
    result = Plist::parse_xml(PLIST_LOCATION)
    result['LogLocationEnabled'] = true
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def disableGeolocation
    result = Plist::parse_xml(PLIST_LOCATION)
    result['LogLocationEnabled'] = false
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def enableGestureDetector
    result = Plist::parse_xml(PLIST_LOCATION)
    result['SetGestureDetector'] = true
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def disableGestureDetector
    result = Plist::parse_xml(PLIST_LOCATION)
    result['SetGestureDetector'] = false
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def disableNativeGestureCaptureOnWebView
    result = Plist::parse_xml(PLIST_LOCATION)
    result['CaptureNativeGesturesOnWebview'] = false
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def enableNativeGestureCaptureOnWebView
    result = Plist::parse_xml(PLIST_LOCATION)
    result['CaptureNativeGesturesOnWebview'] = true
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def setSecureTextFieldMaskingLevel(logLevel)
    result = Plist::parse_xml(PLIST_LOCATION)
    result['Masking']['UITextFieldSecure'] = logLevel
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def setStandardMaskingLevel
    result = Plist::parse_xml(PLIST_LOCATION)
    result['Masking']['HasMasking'] = true
    result['Masking']['HasCustomMask'] = false
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def setCustomMaskingLevel
    result = Plist::parse_xml(PLIST_LOCATION)
    result['Masking']['HasMasking'] = true
    result['Masking']['HasCustomMask'] = true
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def enableIP
    puts 'Inside enableIp'
    file = File.read(ADV_CONFIG_JSON)
    result = JSON.parse(file)  #IO.read(ADV_CONFIG_JSON))
    result['RemoveIp'] = false
    res = JSON.pretty_generate(result)
    File.write(ADV_CONFIG_JSON, res)
    puts 'enable completed'
  end

  def maskIP
    file = File.read(ADV_CONFIG_JSON)
    result = JSON.parse(file)  #IO.read(ADV_CONFIG_JSON))
    result['RemoveIp'] = true
    res = JSON.pretty_generate(result)
    File.write(ADV_CONFIG_JSON, res)
  end

  def appendMapId(id, midValue)
    file = File.read(LAYOUT_CONFIG_JSON)
    result = JSON.parse(file)
    result['AppendMapIds'][id] = {"mid" => midValue}
    res = JSON.pretty_generate(result)
    puts "Result JSON: #{res}"
    File.write(LAYOUT_CONFIG_JSON, res)
  end

  def addAutoLayoutElement(className, valuesDict)
    file = File.read(LAYOUT_CONFIG_JSON)
    result = JSON.parse(file)
    result['AutoLayout'][className] = valuesDict
    res = JSON.pretty_generate(result)
    puts "Result JSON: #{res}"
    File.write(LAYOUT_CONFIG_JSON, res)
  end

  def setAppKey(key)
    result = Plist::parse_xml(PLIST_LOCATION)
    result['AppKey'] = key
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def setPostMessageURL(url)
    result = Plist::parse_xml(PLIST_LOCATION)
    result['PostMessageUrl'] = url
    result.to_plist
    Plist::Emit.save_plist(result, PLIST_LOCATION)
  end

  def setManualPost
    result = Plist::parse_xml(EO_CORE_CONFIG)
    result['ManualPostEnabled'] = true
    result.to_plist
    Plist::Emit.save_plist(result, EO_CORE_CONFIG)
  end

  def disableManualPost
    result = Plist::parse_xml(EO_CORE_CONFIG)
    result['ManualPostEnabled'] = false
    result.to_plist
    Plist::Emit.save_plist(result, EO_CORE_CONFIG)
  end
end

# create an object
#obj = ConfigureTLFResource.new
#puts 'Enabling KillSwitch'
#obj.enableKillSwitch()
#puts 'Disable KillSwitch'
#obj.disableKillSwitch()
#puts 'Setting secure textField masking level to 3'
#obj.setSecureTextFieldMaskingLevel(3)
#obj.enableGestureDetector()

#puts 'Enabling IP'
#obj.enableIP
#obj.appendMapId("[w,1],[v,1],[v,1],[v,0],[v,0],[t,0]", "customField_Peggy")
#obj.addAutoLayoutElement("HomeViewController", {"do" => true, "screenViewName" => "Banana", "delay" => 120, "takeScreenShot" => false})
