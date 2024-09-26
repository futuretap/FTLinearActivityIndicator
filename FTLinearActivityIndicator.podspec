Pod::Spec.new do |s|
  s.name             = 'FTLinearActivityIndicator'
  s.version          = '2.0'
  s.summary          = 'Add the missing network activity indicator on newer iPhones'

  s.description      = <<-DESC
	 Since iOS 18, network activity indicator is no longer displayed. iPhones with a notch
	 or Dynamic Island never displayed it. This pod brings it back by placing an activity
	 indicator in the upper right of the screen on top of the regular status bar items
	 (on top of the clock on iPhone SE running iOS 18+).
	 Since a circular indicator wouldn't fit, a rectangular "KITT scanner" like indicator
	 with a gradient is shown. The indicator UI can be used standalone or as a "fix" for
	 the iOS network activity indicator (using the existing API).
                       DESC

  s.homepage         = 'https://github.com/futuretap/FTLinearActivityIndicator'
  s.screenshots      = 'https://github.com/futuretap/FTLinearActivityIndicator/raw/master/screenshot.gif'
  s.license          = { :type => 'CC-BY-SA 4.0', :file => 'LICENSE' }
  s.author           = 'Ortwin Gentz'
  s.source           = { :git => 'https://github.com/futuretap/FTLinearActivityIndicator.git', :tag => s.version.to_s }
  s.social_media_url = 'https://mastodon.cloud/@ortwingentz'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'FTLinearActivityIndicator/Classes/**/*'
  
  s.frameworks = 'UIKit'
end
