import Flutter
import UIKit
import DynamsoftBarcodeReader
import DynamsoftCameraEnhancer

public protocol DetectionHandler {
        func onDetected(data: NSArray)
    }

class FLQRCodeScanner: NSObject, DBRTextResultDelegate {

    private var cameraView: DCECameraView
    private var dce: DynamsoftCameraEnhancer
    private var barcodeReader: DynamsoftBarcodeReader! = nil
    private var handler: DetectionHandler?

    init(cameraView: DCECameraView, dce: DynamsoftCameraEnhancer) {
        self.cameraView = cameraView
        self.cameraView.overlayVisible = true
        self.dce = dce
        super.init()

        createBarcodeReader(dce: dce)
    }

    func setDetectionHandler(handler: DetectionHandler) {
        self.handler = handler;
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
            let outResults = NSMutableArray()
            for item in results! {
                let subDic = NSMutableDictionary()
                if item.barcodeFormat_2 != EnumBarcodeFormat2.Null {
                    subDic.setObject(item.barcodeFormatString_2 ?? "", forKey: "format" as NSCopying)
                }else{
                    subDic.setObject(item.barcodeFormatString ?? "", forKey: "format" as NSCopying)
                }
                subDic.setObject(item.barcodeText ?? "", forKey: "text" as NSCopying)
                let points = item.localizationResult?.resultPoints as! [CGPoint]
                subDic.setObject(Int(points[0].x), forKey: "x1" as NSCopying)
                subDic.setObject(Int(points[0].y), forKey: "y1" as NSCopying)
                subDic.setObject(Int(points[1].x), forKey: "x2" as NSCopying)
                subDic.setObject(Int(points[1].y), forKey: "y2" as NSCopying)
                subDic.setObject(Int(points[2].x), forKey: "x3" as NSCopying)
                subDic.setObject(Int(points[2].y), forKey: "y3" as NSCopying)
                subDic.setObject(Int(points[3].x), forKey: "x4" as NSCopying)
                subDic.setObject(Int(points[3].y), forKey: "y4" as NSCopying)
                subDic.setObject(item.localizationResult?.angle ?? 0, forKey: "angle" as NSCopying)
                outResults.add(subDic)
            }
            
            if handler != nil {
                handler!.onDetected(data: outResults)
            }
        }
    } 

    func startScan() {
        cameraView.overlayVisible = true
        barcodeReader.startScanning()
    }

    func stopScan() {
        cameraView.overlayVisible = false
        barcodeReader.stopScanning()
    }

    func setBarcodeFormats(arg:NSDictionary) {
        let formats:Int = arg.value(forKey: "formats") as! Int
        let settings = try! barcodeReader!.getRuntimeSettings()
        settings.barcodeFormatIds = formats
        barcodeReader!.update(settings, error: nil)
    }

    func setLicense(license: String) {
        barcodeReader.license = license
    }
}