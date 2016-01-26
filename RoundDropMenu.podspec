#
# Be sure to run `pod lib lint RoundDropMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RoundDropMenu"
  s.version          = "1.0.0"
  s.summary          = "Simple menu written on Swift that ideally suits small sets of visual data."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  "Simple highly customizable iOS component written in Swift gives you another way to represent data. Round-Drop-Menu is great for small sets of visual information."
                       DESC

  s.homepage         = "https://github.com/burntheroad/RoundDropMenu"
  # s.screenshots     = "https://camo.githubusercontent.com/c15a3487eec988653ac84155257f7490275acc98/687474703a2f2f692e696d6775722e636f6d2f674a4c446d41502e676966"
  s.license          = 'MIT'
  s.author           = { "burntheroad" => "gibslp69@gmail.com" }
  s.source           = { :git => "https://github.com/burntheroad/RoundDropMenu.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'RoundDropMenu' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
