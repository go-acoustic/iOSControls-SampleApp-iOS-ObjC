# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

#source 'https://github.com/CocoaPods/Specs.git'

target 'iOSControls' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'TealeafDebug'
  # Pods for iOSControls

  #pod 'Calabash'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings.delete 'ARCHS'
    end
  end
end