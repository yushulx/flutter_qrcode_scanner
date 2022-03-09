import Flutter
import UIKit

public class SwiftFlutterCameraQrcodeScannerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {  
    let factory = FLNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "com.dynamsoft.flutter_camera_qrcode_scanner/nativeview")
  }
}
