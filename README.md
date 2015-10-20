# POPSUGAR ShopSense Client for Objective-C
**Readers click, you get money.**  

The POPSUGAR ShopSense is a free service that pays you for sending quality traffic to online retailers.

Learn more and get started on our [website](http://shopsense.shopstyle.com)!


## Getting Started

Check out the example project that is included in the repository. It is a somewhat simple demonstration of an app that uses `POPSUGARShopSense` to communicate with the POPSUGAR ShopSense API. 

**Also, don't forget to pull down AFNetworking with** `git submodule update --init` **if you want to run the example.** 

## Requirements

POPSUGARShopSense requires Xcode 4.4 with either the [iOS 5.0](http://developer.apple.com/library/ios/#releasenotes/General/WhatsNewIniPhoneOS/Articles/iOS5.html) or [Mac OS 10.6](http://developer.apple.com/library/mac/#releasenotes/MacOSX/WhatsNewInOSX/Articles/MacOSX10_6.html#//apple_ref/doc/uid/TP40008898-SW7) ([64-bit with modern Cocoa runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtVersionsPlatforms.html)) SDK, as well as [AFNetworking](https://github.com/afnetworking/afnetworking) 1.0 or higher.

## Installation

[CocoaPods](http://cocoapods.org) is the recommended way to add POPSUGARShopSense to your project.

Here's an example podfile that installs POPSUGARShopSense and its dependency, AFNetworking. 
### Podfile

```ruby
platform :ios, '5.0'

pod 'POPSUGARShopSense', :git => 'https://github.com/PopSugar/objc-POPSUGAR-ShopSense-client.git'
```

Note the specification of iOS 5.0 as the platform; leaving out the 5.0 will cause CocoaPods to fail with the following message:

> [!] POPSUGARShopSense is not compatible with iOS 4.3.

Alternatively you can copy all of the files in the POPSUGARShopSense folder into your project as well as AFNetworking.

## Contact

Contact us on our [website](http://shopsense.shopstyle.com).

## License

The POPSUGAR ShopSense Client for Objective-C and AFNetworking are available under the MIT license. See the LICENSE file for more info.


## Credits

AFNetworking was created by [Mattt Thompson](https://github.com/mattt/).
