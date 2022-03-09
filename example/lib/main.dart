import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_camera_qrcode_scanner/flutter_camera_qrcode_scanner.dart';
import 'package:flutter_camera_qrcode_scanner/dynamsoft_barcode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScannerViewController? controller;
  String _barcodeResults = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Scanner'),
        ),
        body: Stack(children: <Widget>[
          ScannerView(onScannerViewCreated: onScannerViewCreated),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 100,
                child: SingleChildScrollView(
                  child: Text(
                    _barcodeResults,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 100,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                          child: Text('Start Scan'),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () async {
                            controller!.startScanning();
                          }),
                      MaterialButton(
                          child: Text("Stop Scan"),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () async {
                            controller!.stopScanning();
                          })
                    ]),
              ),
            ],
          )
        ]),
      ),
    );
  }

  void onScannerViewCreated(ScannerViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.setLicense('LICENSE-KEY');
    controller.startScanning(); // auto start scanning
    controller.scannedDataStream.listen((results) {
      setState(() {
        _barcodeResults = getBarcodeResults(results);
      });
    });
  }

  String getBarcodeResults(List<BarcodeResult> results) {
    StringBuffer sb = new StringBuffer();
    for (BarcodeResult result in results) {
      sb.write(result.format);
      sb.write("\n");
      sb.write(result.text);
      sb.write("\n\n");
    }
    if (results.isEmpty) sb.write("No QR Code Detected");
    return sb.toString();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
