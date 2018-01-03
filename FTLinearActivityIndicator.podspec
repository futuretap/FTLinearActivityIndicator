#
# Be sure to run `pod lib lint FTLinearActivityIndicator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FTLinearActivityIndicator'
  s.version          = '0.1.0'
  s.summary          = 'Add the missing network activity indicator on iPhone X'

  s.description      = <<-DESC
 	 iPhone X does not display the network activity indicator anymore. This pod brings it
 	 back by placing an activity indicator in the upper left of the screen on top of the
 	 regular status bar items. Since a circular indicator wouldn't fit, a rectangular 
 	 "KITT scanner" like indicator with a gradient is shown. The indicator UI can be
 	 used standalone or as a "fix" for the iOS network activity indicator (using the
 	 existing API).
                       DESC

  s.homepage         = 'https://github.com/futuretap/FTLinearActivityIndicator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Ortwin Gentz'
  s.source           = { :git => 'https://github.com/futuretap/FTLinearActivityIndicator.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ortwingentz'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FTLinearActivityIndicator/Classes/**/*'
  
  s.frameworks = 'UIKit'
end
