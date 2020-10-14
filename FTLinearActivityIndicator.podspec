Pod::Spec.new do |s|
  s.name             = 'FTLinearActivityIndicator'
  s.version          = '1.3'
  s.summary          = 'Add the missing network activity indicator on iPhone X'

  s.description      = <<-DESC
 	 iPhones with a notch such as X, XS, XR, 11, 11 Pro don't display the network activity
 	 indicator anymore. This pod brings it back by placing an activity indicator in the 
 	 upper left of the screen on top of the regular status bar items. Since a circular
 	 ndicator wouldn't fit, a rectangular "KITT scanner" like indicator with a gradient is 
 	 shown. The indicator UI can be used standalone or as a "fix" for the iOS network 
 	 activity indicator (using the existing API).
                       DESC

  s.homepage         = 'https://github.com/futuretap/FTLinearActivityIndicator'
  s.screenshots      = 'https://github.com/futuretap/FTLinearActivityIndicator/raw/master/screenshot.gif'
  s.license          = { :type => 'CC-BY-SA 4.0', :file => 'LICENSE' }
  s.author           = 'Ortwin Gentz'
  s.source           = { :git => 'https://github.com/futuretap/FTLinearActivityIndicator.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ortwingentz'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'FTLinearActivityIndicator/Classes/**/*'
  
  s.frameworks = 'UIKit'
end
