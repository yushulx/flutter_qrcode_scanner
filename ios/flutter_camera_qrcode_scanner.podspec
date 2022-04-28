#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_camera_qrcode_scanner.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_camera_qrcode_scanner'
  s.version          = '1.0.0'
  s.summary          = 'A lightweight Flutter widget for QR code scanning.'
  s.description      = <<-DESC
  A lightweight Flutter widget for QR code scanning.
                       DESC
  s.homepage         = 'https://github.com/yushulx/flutter_qrcode_scanner'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'yushulx' => 'lingxiao1002@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.dependency 'DynamsoftBarcodeReader', '9.0.1'
  s.dependency 'DynamsoftCameraEnhancer', '2.1.3'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
