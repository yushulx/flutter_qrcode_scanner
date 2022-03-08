import Flutter
import UIKit

public class SwiftFlutterCameraQrcodeScannerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = FLNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "com.dynamsoft.flutter_camera_qrcode_scanner/nativeview")
    
    let channel = FlutterMethodChannel(name: "flutter_camera_qrcode_scanner", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterCameraQrcodeScannerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
