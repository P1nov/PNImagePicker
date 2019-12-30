#
# Be sure to run `pod lib lint PNImagePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PNImagePicker'
  s.version          = '1.1.4'
  s.summary          = 'A conveninent ImagePicker Tool for U'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/P1nov/PNImagePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'P1no' => '1473781785@qq.com' }
  s.source           = { :git => 'https://github.com/P1nov/PNImagePicker.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = ['5.0', '5.1', '4.2', '4.0']

  s.source_files = 'PNImagePicker/Classes/*.swift'
  
  # s.resource_bundles = {
  #   'PNImagePicker' => ['PNImagePicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation', 'Photos'
end
