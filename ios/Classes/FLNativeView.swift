import Flutter
import UIKit
import DynamsoftCameraEnhancer

class FLNativeView: NSObject, FlutterPlatformView, DetectionHandler {
    private var _view: UIView
    private var messenger: FlutterBinaryMessenger
    private var channel: FlutterMethodChannel
    private var qrCodeScanner: FLQRCodeScanner
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger: FlutterBinaryMessenger
    ) {
        self.messenger = binaryMessenger
        let cameraView = DCECameraView.init(frame: frame)
        let dce = DynamsoftCameraEnhancer.init(view: cameraView)
        dce.open()
        dce.setFrameRate(30)
        _view = cameraView

        qrCodeScanner = FLQRCodeScanner.init(cameraView: cameraView, dce: dce)

        channel = FlutterMethodChannel(name: "com.dynamsoft.flutter_camera_qrcode_scanner/nativeview_" + String(viewId), binaryMessenger: messenger)
        
        super.init()

        qrCodeScanner.setDetectionHandler(handler: self)
        channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
                case "startScanning":
                    self.qrCodeScanner.startScan()
                    result(.none)
                case "stopScanning":
                    self.qrCodeScanner.stopScan()
                    result(.none)
                case "setLicense":
                    self.qrCodeScanner.setLicense(license: (call.arguments as! NSDictionary).value(forKey: "license") as! String)
                    result(.none)
                case "setBarcodeFormats":
                    self.qrCodeScanner.setBarcodeFormats(arg: call.arguments as! NSDictionary)
                    result(.none)
                default:
                    result(.none)
                }
        })
    }

    func view() -> UIView {
        return _view
    }

    func onDetected(data: NSArray) {
        DispatchQueue.main.async {
                self.channel.invokeMethod("onDetected", arguments: data)
            }
    }
}
