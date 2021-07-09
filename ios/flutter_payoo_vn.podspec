#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_payoo_vn.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_payoo_vn'
  s.version          = '0.0.1'
  s.summary          = 'This plugin helps in integrating the Payoo.vn native mobile SDK into Flutter application project.'
  s.description      = <<-DESC
This plugin helps in integrating the Payoo.vn native mobile SDK into Flutter application project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  #  s.resource_bundle = { '<Your framework name>-Resources' => './*' }
  s.preserve_paths = 'ExternalFrameworks/PayooCore.xcframework', 'ExternalFrameworks/PayooPayment.xcframework', 'ExternalFrameworks/PayooService.xcframework', 'ExternalFrameworks/PayooTopup.xcframework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework PayooCore -framework PayooPayment -framework PayooService -framework PayooTopup' }
  s.vendored_frameworks = 'ExternalFrameworks/PayooCore.xcframework', 'ExternalFrameworks/PayooPayment.xcframework', 'ExternalFrameworks/PayooService.xcframework', 'ExternalFrameworks/PayooTopup.xcframework'

end
