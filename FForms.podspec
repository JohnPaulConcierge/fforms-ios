Pod::Spec.new do |s|

  s.name         = "FForms"
  s.version      = "0.1.0"
  s.summary      = "Field based form library"
  s.license      = "JohnPaul"
  s.homepage     = "https://github.com/JohnPaulConcierge/fforms-ios"
  s.author             = { "JP Mobile" => "mobile@johnpaul.com" }
  s.source       = { :git => "https://github.com/JohnPaulConcierge/fforms-ios.git", :tag => "#{s.version}" }
  
  s.source_files  = "FForms/**/*.swift"

  s.ios.deployment_target = '9.0'
  
  s.dependency "PhoneNumberKit"

end
