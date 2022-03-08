# Flutter QR Code Scanner
A lightweight Flutter QR code scanner plugin implemented with [Dynamsoft Camera Enhancer](https://www.dynamsoft.com/camera-enhancer/docs/introduction/) and [Dynamsoft Barcode Reader](https://www.dynamsoft.com/barcode-reader/overview/).

## Supported Platforms
- **Android**


## Build Configuration

Change the minimum Android sdk version to 21 (or higher) and change the compile sdk version to 31 (or higher) in your `android/app/build.gradle` file.

```gradle
minSdkVersion 21
compileSdkVersion 31
```

## Try Real-time QR Code Scanning

```bash
cd example
flutter run
```

<img src="https://www.dynamsoft.com/blog/wp-content/uploads/2021/10/flutter-qr-code-scanner.jpg" width="250" alt="Flutter QR Code scanner">

## Usage
- Create a QR code scanner view:
    
    ```dart
    ScannerViewController? controller;
    ScannerView(onScannerViewCreated: onScannerViewCreated);
    void onScannerViewCreated(ScannerViewController controller) {
        setState(() {
          this.controller = controller;
        });
        controller.scannedDataStream.listen((results) {
          
        });
      }
    ```
- Use a [valid license](https://www.dynamsoft.com/customer/license/trialLicense?product=dbr) to activate QR code detection API. 
    
    ```dart
    controller.setLicense('LICENSE-KEY');
    ```

- Use controller to start and stop real-time QR code scanning.
    
    ```dart
    controller.startScanning();
    controller.stopScanning();
    ```