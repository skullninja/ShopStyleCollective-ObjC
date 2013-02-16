Pod::Spec.new do |s|
  s.name         = "PSShoppingAPI"
  s.version      = "0.1.0"
  s.summary      = "Objective-C wrapper for the POPSUGAR Shopping API."
  s.homepage     = "https://github.com/PopSugar/objc-popsugar-shopping-api"
  s.author       = { "Anthony Prato" => "aprato@popsugar.com" }
  s.license      = 'MIT'

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source       = { :git => "https://github.com/PopSugar/objc-popsugar-shopping-api.git", :tag => "0.1.0" }
  s.source_files = 'PSShoppingAPI/*.{h,m}'

  s.requires_arc = true
  
  s.dependency 'AFNetworking', '>= 1.0.0'
end
