#
# Be sure to run `pod lib lint LightweightObservable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LightweightObservable'
  s.version          = '2.1.1'
  s.summary          = 'Lightweight Obserservable is a simple implementation of an observable sequence that you can subscribe to.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Lightweight Obserservable is a simple implementation of an observable sequence that you can subscribe to.
The framework is designed to be minimal meanwhile convenient. The entire code is only ~90 lines (excluding comments).
With Lightweight Observable you can easily set up UI-Bindings in an MVVM application, handle asynchronous network calls and a lot more.
                       DESC

  s.homepage         = 'https://github.com/fxm90/LightweightObservable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Felix Mau' => 'me@felix.hamburg' }
  s.source           = { :git => 'https://github.com/fxm90/LightweightObservable.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_fxm90'

  s.swift_version         = '5.1'
  s.ios.deployment_target = '9.0'

  s.source_files = 'LightweightObservable/Classes/**/*'

  # s.resource_bundles = {
  #   'LightweightObservable' => ['LightweightObservable/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
