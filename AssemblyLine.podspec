#
#  Be sure to run `pod spec lint AssemblyLine.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "AssemblyLine"
  s.version      = "0.1.1"
  s.summary      = "AssemblyLine is a library for easily writing workflows."
  s.description  = <<-DESC
  AssemblyLine processes several tasks continuously in the background.
  Discard tasks that failed during execution during execution.
                   DESC

  s.homepage     = "https://github.com/1amageek/AssemblyLine"
  s.screenshots  = "https://github.com/1amageek/AssemblyLine/blob/master/AssemblyLine.png"
  s.license      = { :type => "MIT", :file => "https://github.com/1amageek/AssemblyLine/blob/master/LICENSE" }
  s.author             = { "1amageek" => "tmy0x3@icloud.com" }
  s.social_media_url   = "http://twitter.com/1amageek"
  s.platform     = :ios#, :macos, :tvos, :watchos
  s.ios.deployment_target = "10.0"
  #s.osx.deployment_target = "10.10"
  #s.watchos.deployment_target = "2.0"
  #s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/1amageek/AssemblyLine.git", :tag => "#{s.version}" }
  s.source_files  = "AssemblyLine", "AssemblyLine/**/*.{swift}"

end
