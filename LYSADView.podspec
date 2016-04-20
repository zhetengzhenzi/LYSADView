

Pod::Spec.new do |s|
  s.name             = "LYSADView"
  s.version          = "0.0.1"
  s.summary          = ""

  s.homepage         = "https://github.com/zhetengzhenzi/LYSADView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "liuyushuang@duia.com" => "liuyushuang@duia.com" }
  s.source           = { :git => "https://github.com/zhetengzhenzi/LYSADView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'

  s.source_files = 'LYSADView/Classes/**/*'
  s.resource_bundles = {
    'LYSADView' => ['LYSADView/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
