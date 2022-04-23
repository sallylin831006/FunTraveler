# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FunTraveler' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FunTraveler
    pod 'SwiftLint'
    pod 'IQKeyboardManagerSwift'
#    pod 'GoogleMaps'
#    pod 'GooglePlaces'
    pod 'Kingfisher'
    pod 'lottie-ios'
    pod 'PusherSwift'
    pod 'JGProgressHUD'



post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
   end
end
end
