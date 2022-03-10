import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_camera_qrcode_scanner/dynamsoft_barcode.dart';

/// Callback function for scanner view creation.
typedef ScannerViewCreatedCallback = void Function(ScannerViewController);

/// A widget showing a live camera preview.
class ScannerView extends StatefulWidget {
  final ScannerViewCreatedCallback onScannerViewCreated;
  const ScannerView({Key? key, required this.onScannerViewCreated})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ScannerViewState();
}

/// State of the [ScannerView].
class _ScannerViewState extends State<ScannerView> {
  ScannerViewController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String viewType =
        'com.dynamsoft.flutter_camera_qrcode_scanner/nativeview';
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }

  /// Platform view created callback.
  void _onPlatformViewCreated(int id) {
    _controller = ScannerViewController(id);
    widget.onScannerViewCreated(_controller!);
  }
}

/// The controller for QR code scanner.
class ScannerViewController {
  late MethodChannel _channel;
  final StreamController<List<BarcodeResult>> _streamController =
      StreamController<List<BarcodeResult>>();
  Stream<List<BarcodeResult>> get scannedDataStream => _streamController.stream;

  ScannerViewController(int id) {
    _channel = MethodChannel(
        'com.dynamsoft.flutter_camera_qrcode_scanner/nativeview_$id');
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onDetected':
          if (call.arguments != null) {
            List<BarcodeResult> data = fromPlatformData(call.arguments as List);
            _streamController.sink.add(data);
          }
          break;
      }
    });
  }

  /// Dispose the controller.
  void dispose() {
    stopScanning();
    _streamController.close();
  }

  /// Start QR Code scanning.
  Future<void> startScanning() async {
    await _channel.invokeMethod('startScanning');
  }

  /// Stop QR Code scanning.
  Future<void> stopScanning() async {
    await _channel.invokeMethod('stopScanning');
  }

  /// Set Dynamsoft Barcode Reader License Key.
  /// Apply for a 30-day FREE trial license: https://www.dynamsoft.com/customer/license/trialLicense
  Future<void> setLicense(String license) async {
    await _channel.invokeMethod('setLicense', {'license': license});
  }

  /// Set barcode formats.
  /// https://www.dynamsoft.com/barcode-reader/parameters/enum/format-enums.html?ver=latest#barcodeformat
  Future<int> setBarcodeFormats(int formats) async {
    return await _channel
        .invokeMethod('setBarcodeFormats', {'formats': formats});
  }
}
