# FTLinearActivityIndicator

[![Version](https://img.shields.io/cocoapods/v/FTLinearActivityIndicator.svg?style=flat)](http://cocoapods.org/pods/FTLinearActivityIndicator)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swiftpackageindex.com/futuretap/FTLinearActivityIndicator)
[![License](https://img.shields.io/cocoapods/l/FTLinearActivityIndicator.svg?style=flat)](https://creativecommons.org/licenses/by-sa/4.0/)
[![Platform](https://img.shields.io/cocoapods/p/FTLinearActivityIndicator.svg?style=flat)](http://cocoapods.org/pods/FTLinearActivityIndicator)
[![Sponsor](https://img.shields.io/badge/Sponsor-ff40a0)](https://github.com/sponsors/futuretap)
[![Mastodon](https://img.shields.io/mastodon/follow/000010558?domain=https%3A%2F%2Fmastodon.cloud)](https://mastodon.cloud/@ortwingentz)

Since iOS 18, network activity indicator is no longer displayed. iPhones with a notch or Dynamic Island 
[never displayed it](http://www.futuretap.com/blog/fix-for-the-missing-network-activity-indicator-on-iphone-x).
This framework brings it back by placing an activity indicator in the upper right of the screen on top of the
regular status bar items (on top of the clock on iPhone SE running iOS 18+).

Since a circular indicator wouldn't fit, a rectangular [KITT scanner](https://giphy.com/gifs/80s-nbc-knight-rider-Bo2WsocASVBm0)-like indicator with a gradient is shown. The indicator UI can be used standalone or as a "fix" for the iOS network activity indicator (using the existing API).

<img src="https://github.com/futuretap/FTLinearActivityIndicator/blob/master/screenshot.gif?raw=true">

## Integration
### As a fix for the system network activity indicator

In your app delegate's `didFinishLaunching` method, **after** initializing the window, just call

    UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()

Then, use the standard network activity indicator as usual.

### As a standalone view

Include a `FTLinearActivityIndicator` view in your storyboard or instantiate it from code. The class supports the following methods and properties, using a similar API as the iOS `UIActivityIndicatorView`:

- `startAnimating()`
- `stopAnimating()`
- `isAnimating: Bool`
- `hidesWhenStopped: Bool`

`tintColor` is supported to colorize the indicator gradient.

## Requirements

- iOS 12 or higher (iOS 11 is supported until version 1.6)
- compiles for Mac Catalyst or visionOS (without network activity indicator)

## Installation

FTLinearActivityIndicator is available through [Swift Package Manager](https://swiftpackageindex.com/futuretap/FTLinearActivityIndicator) or [CocoaPods](http://cocoapods.org). 

### Swift Package Manager
To install FTLinearActivityIndicator using [Swift Package Manager](https://github.com/apple/swift-package-manager) you can follow the [tutorial published by Apple](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) using the URL for the FTLinearActivityIndicator repo with the current version:

1. In Xcode, select “File” → “Add Packages…”
1. Enter `https://github.com/futuretap/FTLinearActivityIndicator.git`

### CocoaPods
To install FTLinearActivityIndicator via CocoaPods, add the following line to your Podfile:

```ruby
pod 'FTLinearActivityIndicator'
```

Then run `pod install`.

To open an example project, just call `pod try FTLinearActivityIndicator` on the command line.

## Author
Developed by [Ortwin Gentz](https://www.futuretap.com/about/ortwin-gentz) ([Mastodon](https://mastodon.cloud/@ortwingentz)) and used in [FutureTap](https://www.futuretap.com)’s [Where To?](https://wheretoapp.com) and [Streets](https://streets.app) apps – we eat our own dog food!

## License
FTLinearActivityIndicator is available under the [CC-BY-SA 4.0 license](http://creativecommons.org/licenses/by-sa/4.0/). You may copy and redistribute, adapt and build upon the framework for any purpose, even commercially, as long as you give credit to me in the About menu or a similar place in the app.
If you need a different license without attribution requirement, please contact me and we can work something out.

## Sponsors wanted
If you would like to support my Open Source work, consider joining me as a [sponsor](https://github.com/sponsors/futuretap)! 💪️ Your sponsorship enables me to spend more time on this and other community projects. Thank you!
