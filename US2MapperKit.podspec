Pod::Spec.new do |s|
  s.name         = "US2MapperKit"
  s.version      = "0.0.1"
  s.summary      = "JSON Mapping Framework"
  s.homepage     = "https://github.com/ustwo/US2MapperKit/tree/03-Code-Review-Refactor"

  s.license      = 'MIT'
  s.author       = { "Anton Doudarev" => "anton@ustwo.com"}
  s.source       = { :git => 'https://github.com/ustwo/US2MapperKit.git', :branch => '03-Code-Review-Refactor'}
  s.source_files = ‘Source/*.*’
  s.requires_arc = true
end