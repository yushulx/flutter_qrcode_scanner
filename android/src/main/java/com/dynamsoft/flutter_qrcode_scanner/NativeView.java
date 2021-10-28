package com.dynamsoft.flutter_qrcode_scanner;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.platform.PlatformViewFactory;
import android.app.Activity;
import android.app.Application;
import com.dynamsoft.dce.*;
import com.dynamsoft.dbr.*;
import android.os.Bundle;
import android.util.Log;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class NativeView implements PlatformView, MethodCallHandler, Application.ActivityLifecycleCallbacks, QRCodeScanner.DetectionHandler {
    @NonNull
    private final DCECameraView cameraView;
    private MethodChannel methodChannel;
    private QRCodeScanner qrCodeScanner;
    private Activity context;

    NativeView(BinaryMessenger messenger, @NonNull Activity context, int id,
            @Nullable Map<String, Object> creationParams) {
        this.context = context;
        context.getApplication().registerActivityLifecycleCallbacks(this);
        
        cameraView = new DCECameraView(context);
        qrCodeScanner = new QRCodeScanner(context, cameraView);
        qrCodeScanner.setDetectionHandler(this);

        methodChannel = new MethodChannel(messenger, "com.dynamsoft.flutter_qrcode_scanner/nativeview_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    @NonNull
    @Override
    public View getView() {
        return cameraView;
    }

    @Override
    public void dispose() {
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
        case "startScanning":
            qrCodeScanner.startScan();
            result.success(null);
            break;
        case "stopScanning":
            qrCodeScanner.stopScan();
            result.success(null);
            break;
        case "setLicense":
            final String license = call.argument("license");
            qrCodeScanner.setLicense(license);
            result.success(null);
            break;
        case "setBarcodeFormats":
            final int formats = call.argument("formats");
            qrCodeScanner.setBarcodeFormats(formats);
            result.success(null);
            break;
        default:
            result.notImplemented();
        }
    }

    @Override
    public void onDetected(List<Map<String, Object>> data) {
        context.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                methodChannel.invokeMethod("onDetected", data);
            }
        });
    }

    @Override
    public void onActivityResumed(Activity activity) {
        qrCodeScanner.startScan();
    }

    @Override
    public void onActivityPaused(Activity activity) {
        qrCodeScanner.stopScan();
    }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

    }

    @Override
    public void onActivityStopped(Activity activity) {
    }

    @Override
    public void onActivityStarted(Activity activity) {

    }

    @Override
    public void onActivityCreated(Activity activity, Bundle bundle) {
    }
}