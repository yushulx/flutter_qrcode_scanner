import Flutter
import UIKit
import DynamsoftBarcodeReader
import DynamsoftCameraEnhancer

class FLNativeView: NSObject, FlutterPlatformView, DetectionHandler, DBRLicenseVerificationListener {
    private var _view: UIView
    private var messenger: FlutterBinaryMessenger
    private var channel: FlutterMethodChannel
    private var qrCodeScanner: FLQRCodeScanner
    private var cameraView: DCECameraView
    private var dce: DynamsoftCameraEnhancer
    var completionHandlers: [FlutterResult] = []
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger: FlutterBinaryMessenger
    ) {
        self.messenger = binaryMessenger
        cameraView = DCECameraView.init(frame: frame)
        dce = DynamsoftCameraEnhancer.init(view: cameraView)
        _view = cameraView

        qrCodeScanner = FLQRCodeScanner()

        channel = FlutterMethodChannel(name: "com.dynamsoft.flutter_camera_qrcode_scanner/nativeview_" + String(viewId), binaryMessenger: messenger)
        
        super.init()

        qrCodeScanner.setDetectionHandler(handler: self)
        channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
                case "init":
                    self.qrCodeScanner.initScanner(cameraView: cameraView, dce: dce)
                    result(.none)
                case "startScanning":
                    self.qrCodeScanner.startScan()
                    result(.none)
                case "stopScanning":
                    self.qrCodeScanner.stopScan()
                    result(.none)
                case "setLicense":
                    completionHandlers.append(result)
                    self.qrCodeScanner.setLicense(license: (call.arguments as! NSDictionary).value(forKey: "license") as! String, verificationDelegate: self)
                case "setBarcodeFormats":
                    self.qrCodeScanner.setBarcodeFormats(arg: call.arguments as! NSDictionary)
                    result(.none)
                default:
                    result(.none)
                }
        })
    }

    public func dbrLicenseVerificationCallback(_ isSuccess: Bool, error: Error?)
    {
        completionHandlers.first?(.none)
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
