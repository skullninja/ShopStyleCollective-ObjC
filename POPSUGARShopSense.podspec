Pod::Spec.new do |s|
  s.name         = "POPSUGARShopSense"
  s.version      = "0.2.0"
  s.summary      = "Objective-C client for the POPSUGAR ShopSense API."
  s.homepage     = "https://github.com/PopSugar/objc-POPSUGAR-ShopSense-client"
  s.author       = { "Anthony Prato" => "aprato@popsugar.com" }
  s.license      = 'MIT'

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source       = { :git => "https://github.com/PopSugar/objc-POPSUGAR-ShopSense-client.git", :tag => "0.2.0" }
  s.source_files = 'POPSUGARShopSense/*.{h,m}'

  s.requires_arc = true
  
  s.dependency 'AFNetworking', '>= 1.0.0'
end
