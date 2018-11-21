Pod::Spec.new do |s|
  s.ios.deployment_target  =  '5.0'
  s.osx.deployment_target  = '10.9'
  s.tvos.deployment_target =  '9.0'
  s.name     = 'SYProxy'
  s.version  = '1.0.1'
  s.license  = 'Custom'
  s.summary  = 'NSURLProtocol subclass to implement in-app proxying'
  s.homepage = 'https://github.com/dvkch/SYProxy'
  s.author   = { 'Stan Chevallier' => 'contact@syan.me' }
  s.source   = { :git => 'https://github.com/dvkch/SYProxy.git', :tag => s.version.to_s }
  s.source_files = 'SYProxy/*.{h,m}'
  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
end
