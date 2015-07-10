Pod::Spec.new do |s|
  s.name         = "US2MapperKit"
  s.version      = "0.0.1"
  s.summary      = "Mapping"
  s.homepage     = "https://github.com/ustwo/US2MapperKit"

  s.license      = 'MIT'
  s.author       = { "Anton Doudarev" => "anton@ustwo.com" }
  s.source       = { :git => "https://github.com/ustwo/US2MapperKit.git" }
  s.platform     = :ios
  s.source_files = "Source"
  s.requires_arc = true
end
