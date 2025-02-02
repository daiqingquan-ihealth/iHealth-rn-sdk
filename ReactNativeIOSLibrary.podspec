require "json"
package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "ReactNativeIOSLibrary"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package['homepage']
  s.license      = package['license']
  s.authors      = package['author']

  s.platform     = :ios, "12.0"
  s.ios.deployment_target = '12.0'
  s.source       = { :git => "https://github.com/iHealthLab/iHealth-rn-sdk.git", :tag => "v#{s.version}" }
  s.source_files = "ios/**/*.{h,m}"
  s.public_header_files = "ios/ReactNativeIOSLibrary/Communication_SDK/Headers/*.h"
  s.vendored_libraries  = "ios/ReactNativeIOSLibrary/Communication_SDK/libiHealthSDK2.13.0.a"
  s.requires_arc = true

  s.dependency 'React-Core'
end
