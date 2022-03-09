import Flutter
import UIKit
import DynamsoftBarcodeReader
import DynamsoftCameraEnhancer

class FLNativeView: NSObject, FlutterPlatformView, DBRTextResultDelegate {
    private var _view: UIView
    private var dceView: DCECameraView! = nil
    private var barcodeReader: DynamsoftBarcodeReader! = nil
    private var dce: DynamsoftCameraEnhancer! = nil
    private var messenger: FlutterBinaryMessenger
    private var channel: FlutterMethodChannel
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger: FlutterBinaryMessenger
    ) {
        self.messenger = binaryMessenger
        dceView = DCECameraView.init(frame: frame)
        dce = DynamsoftCameraEnhancer.init(view: dceView)
        dce.open()
        dce.setFrameRate(30)
        _view = dceView

        channel = FlutterMethodChannel(name: "com.dynamsoft.flutter_camera_qrcode_scanner/nativeview_" + String(viewId), binaryMessenger: messenger)
        channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
                case "startScanning":
                    print("startScanning")
                    result(.none)
                case "stopScanning":
                    print("stopScanning")
                    result(.none)
                case "setLicense":
                    print("setLicense")
                    result(.none)
                case "setBarcodeFormats":
                    print("setBarcodeFormats")
                    result(.none)
                default:
                    result(.none)
                }
        })
        super.init()

        createBarcodeReader(dce: dce)
    }

    func view() -> UIView {
        return _view
    }

    func createBarcodeReader(dce: DynamsoftCameraEnhancer) {
        // To activate the sdk, apply for a license key: https://www.dynamsoft.com/customer/license/trialLicense?product=dbr
        barcodeReader = DynamsoftBarcodeReader.init(license: "license-key")
        barcodeReader.setCameraEnhancer(dce)

        // Set text result call back to get barcode results.
        barcodeReader.setDBRTextResultDelegate(self, userData: nil)

        // Start the barcode decoding thread.
        barcodeReader.startScanning()
    }

    func textResultCallback(_ frameId: Int, results: [iTextResult]?, userData: NSObject?) {
        if results!.count > 0 {
            var msgText:String = ""
            for item in results! {
                if item.barcodeFormat_2.rawValue != 0 {
                    msgText = msgText + String(format:"\nFormat: %@\nText: %@\n", item.barcodeFormatString_2!, item.barcodeText ?? "noResuslt")
                }else{
                    msgText = msgText + String(format:"\nFormat: %@\nText: %@\n", item.barcodeFormatString!,item.barcodeText ?? "noResuslt")
                }
            }
            DispatchQueue.main.async {
                print(msgText)
                self.channel.invokeMethod("onDetected", arguments: msgText)
            }
        }
    } 
}
