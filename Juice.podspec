#
# Be sure to run `pod lib lint Juice.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Juice'
  s.version          = '1.0.1'
  s.summary          = 'A modern and simple JSON Encoder / Decoder for Swift 3'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Juice is a modern and simple JSON Encoder / Decoder for Swift 3
Features:
* Written to take full advantage of Swift's ability to throw errors.
* If a required parameter is missing or the wrong type, Juice will tell you exactly which model and key - for easy debugging.
* Easy to use. No weird <*> <|?> <:3>-operators. Just use decode, Juice will figure out the rest.
* Ability to transform values when encoding / decoding.
* ...and of course many, many test cases!
                       DESC

  s.homepage         = 'https://github.com/rundfunk47/Juice'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Narek Mailian' => 'narek.mailian@gmail.com' }
  s.source           = { :git => 'https://github.com/rundfunk47/Juice.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Juice/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Juice' => ['Juice/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
