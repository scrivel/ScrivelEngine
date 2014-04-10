
Pod::Spec.new do |s|

  s.name         = "ScrivelEngine"
  s.version      = "0.0.1"
  s.summary      = "A short description of ScrivelEngine."

  s.description  = <<-DESC
                   A longer description of ScrivelEngine in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/scrivel/ScrivelEngine"
  s.license      = 'MIT'

  s.author             = { "Yusuke Sakurai" => "kerokerokerop@gmail.com" }
  s.social_media_url = "http://twitter.com/keroxp"

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'


  s.source       = { :git => "https://github.com/scrivel/ScrivelEngine.git", :tag => "0.0.1" }

  s.source_files  = 'ScrivelEngine', 'ScrivelEngine/**/*.{h,m}'
  s.ios.exclude_files = 'ScrivelEngine/OSX/**/*'

  s.public_header_files = 'ScrivelEngine/**/*.h'

  s.resources = "Resources/*.png"

  s.dependency 'ParseKit', '~> 0.7'
  s.dependency 'Mantle', '~> 1.4.1'
  s.dependency 'KXEventEmitter', '~> 0.0.4'

  s.frameworks = 'QuartzCore'

  s.requires_arc = true

  s.prefix_header_file = "ScrivelEngine/ScrivelEngine-Prefix.pch"

end
