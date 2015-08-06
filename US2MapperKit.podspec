Pod::Spec.new do |s|
  s.name         = "US2MapperKit"
  s.version      = "0.1.0"
  s.summary      = "JSON/Dictionary response driven object mapper with support for Swift 1.2 / 2.0"
  s.homepage     = "https://github.com/ustwo/US2MapperKit"
  s.license      = 'MIT'
  s.author       = { "Anton Doudarev" => "anton@ustwo.com" }
  s.source       = { :git => 'https://github.com/ustwo/US2MapperKit.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.source_files = "Source/US2MapperKit/*.*", "Source/ModelScript/*.*"
  s.requires_arc = true
end
