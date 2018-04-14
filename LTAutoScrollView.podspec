#
# Be sure to run `pod lib lint LTAutoScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LTAutoScrollView'
  s.version          = '0.1.0'
  s.summary          = 'LTAutoScrollView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
自定义轮播图，不依赖任何图片加载框架，可实现自定义pageControl，自定义轮播View，自定义滚动样式等等
                       DESC

  s.homepage         = 'https://github.com/gltwy/LTAutoScrollView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1282990794@qq.com' => '1282990794@qq.com' }
  s.source           = { :git => 'https://github.com/gltwy/LTAutoScrollView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LTAutoScrollView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LTAutoScrollView' => ['LTAutoScrollView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
