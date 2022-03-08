import Flutter
import UIKit
import DynamsoftBarcodeReader
import DynamsoftCameraEnhancer

class FLNativeView: NSObject, FlutterPlatformView, DBRTextResultDelegate {
    private var _view: UIView
    private var channel: FlutterMethodChannel
    private var dceView: DCECameraView! = nil
    private var barcodeReader: DynamsoftBarcodeReader! = nil
    private var dce: DynamsoftCameraEnhancer! = nil
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        channel: FlutterMethodChannel
    ) {
        dceView = DCECameraView.init(frame: frame)
        dce = DynamsoftCameraEnhancer.init(view: dceView)
        dce.open()
        dce.setFrameRate(30)
        _view = dceView
        self.channel = channel
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
