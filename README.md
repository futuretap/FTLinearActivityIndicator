# FTLinearActivityIndicator

[![Version](https://img.shields.io/cocoapods/v/FTLinearActivityIndicator.svg?style=flat)](http://cocoapods.org/pods/FTLinearActivityIndicator)
[![License](https://img.shields.io/cocoapods/l/FTLinearActivityIndicator.svg?style=flat)](https://creativecommons.org/licenses/by-sa/4.0/)
[![Platform](https://img.shields.io/cocoapods/p/FTLinearActivityIndicator.svg?style=flat)](http://cocoapods.org/pods/FTLinearActivityIndicator)
[![Twitter](https://img.shields.io/twitter/follow/ortwingentz.svg?style=social&label=Follow)](https://twitter.com/ortwingentz)

iPhone X, XS, and XR don't display the network activity indicator [anymore](http://www.futuretap.com/blog/fix-for-the-missing-network-activity-indicator-on-iphone-x). This framework brings it
back by placing an activity indicator in the upper right of the screen on top of the
regular status bar items.

Since a circular indicator wouldn't fit, a rectangular [KITT scanner](https://giphy.com/gifs/scanner-vD9c1fVxaYZnq)-like indicator with a gradient is shown. The indicator UI can be used standalone or as a "fix" for the iOS network activity indicator (using the existing API).

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

## Example

To open an example project, just call `pod try FTLinearActivityIndicator` on the command line.

## Requirements
Written in Swift 4.2. Should run under any iOS (obviously, the iPhone X requires iOS 11 or higher).

## Installation

FTLinearActivityIndicator is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'FTLinearActivityIndicator'
```

If you need to use Swift 4.0, please use the `swift-4.0` branch:

```ruby
pod 'FTLinearActivityIndicator', :git => 'git@github.com:futuretap/FTLinearActivityIndicator.git', :branch => 'swift-4.0'
```

## Author

Ortwin Gentz, [FutureTap GmbH](https://www.futuretap.com), Twitter: [@ortwingentz](https://twitter.com/ortwingentz)

## License

FTLinearActivityIndicator is available under the [CC-BY-SA 4.0 license](http://creativecommons.org/licenses/by-sa/4.0/). You may copy and redistribute, adapt and build upon the framework for any purpose, even commercially, as long as you give credit to me in the About menu or a similar place in the app.
