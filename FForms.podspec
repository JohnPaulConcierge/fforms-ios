Pod::Spec.new do |s|
  s.name         = 'FForms'
  s.version      = '0.1.3'
  s.summary      = 'Field based form library'
  s.license      = { type: 'MIT', file: 'LICENSE' }
  s.homepage     = 'https://github.com/JohnPaulConcierge/fforms-ios'
  s.author = { 'JP Mobile' => 'mobile@johnpaul.com' }
  s.source = { git: 'https://github.com/JohnPaulConcierge/fforms-ios.git',
               tag: s.version.to_s }
  s.swift_version = '5.0'

  s.source_files  = 'FForms/**/*.swift'

  s.ios.deployment_target = '9.0'

  s.dependency 'PhoneNumberKit'

  s.resource_bundle = { 'FForms' => 'FForms/Resources/*.lproj/*.strings' }
end
