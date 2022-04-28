package com.dynamsoft.flutter_camera_qrcode_scanner;

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

public class QRCodeScanner {
    private CameraEnhancer mCameraEnhancer;
    private BarcodeReader reader;
    private Activity context;
    private DCECameraView cameraView;
    private DetectionHandler handler;

    public interface DetectionHandler {
        public void onDetected(List<Map<String, Object>> data);
    }

    public QRCodeScanner(Activity context, DCECameraView cameraView) {
        this.context = context;
        this.cameraView = cameraView;
        mCameraEnhancer = new CameraEnhancer(context);
        mCameraEnhancer.setCameraView(cameraView);
        cameraView.setOverlayVisible(true);

        try {
            // mCameraEnhancer.open();
            reader = new BarcodeReader();
            reader.setCameraEnhancer(mCameraEnhancer);
            reader.setTextResultListener(mTextResultCallback);
            // PublicRuntimeSettings settings = reader.getRuntimeSettings();
            // settings.barcodeFormatIds = EnumBarcodeFormat.BF_QR_CODE;
            // reader.updateRuntimeSettings(settings);
        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    TextResultListener mTextResultCallback = new TextResultListener() {
        @Override
        public void textResultCallback(int i, ImageData imageData, TextResult[] results) {
            if (results != null) {
                final List<Map<String, Object>> ret = new ArrayList<Map<String, Object>>();
                for (TextResult result: results) {
                    final Map<String, Object> data = new HashMap<>();
                    data.put("format", result.barcodeFormatString);
                    data.put("text", result.barcodeText);
                    data.put("x1", result.localizationResult.resultPoints[0].x);
                    data.put("y1", result.localizationResult.resultPoints[0].y);
                    data.put("x2", result.localizationResult.resultPoints[1].x);
                    data.put("y2", result.localizationResult.resultPoints[1].y);
                    data.put("x3", result.localizationResult.resultPoints[2].x);
                    data.put("y3", result.localizationResult.resultPoints[2].y);
                    data.put("x4", result.localizationResult.resultPoints[3].x);
                    data.put("y4", result.localizationResult.resultPoints[3].y);
                    data.put("angle", result.localizationResult.angle);
                    ret.add(data);
                }

                if (handler != null) {
                    handler.onDetected(ret);
                }
            }
        }
    };

    public void setDetectionHandler(DetectionHandler handler) {
        this.handler = handler;
    }

    public void startScan() {
        try {
            mCameraEnhancer.open();
            cameraView.setOverlayVisible(true);
            reader.startScanning();
        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    public void stopScan() {
        try {
            mCameraEnhancer.close();
            cameraView.setOverlayVisible(false);
            reader.stopScanning();
        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    public int setBarcodeFormats(int formats) {
        try {
            PublicRuntimeSettings settings = reader.getRuntimeSettings();
            settings.barcodeFormatIds = formats;
            reader.updateRuntimeSettings(settings);
            return 0;
        }
        catch(Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public void setLicense(String license) {
        try {
            reader.initLicense(license);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
