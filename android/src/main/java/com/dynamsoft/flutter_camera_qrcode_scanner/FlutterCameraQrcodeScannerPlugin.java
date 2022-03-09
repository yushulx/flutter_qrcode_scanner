package com.dynamsoft.flutter_camera_qrcode_scanner;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import android.app.Activity;
import android.util.Log;
import android.app.Application;
import android.os.Bundle;
import io.flutter.plugin.common.EventChannel;

/** FlutterCameraQrcodeScannerPlugin */
public class FlutterCameraQrcodeScannerPlugin implements FlutterPlugin, ActivityAware {
  private static final String TAG = "FlutterCameraQrcodeScannerPlugin";
  private Activity activity;
  private FlutterPluginBinding flutterPluginBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;
  }

  private void bind(ActivityPluginBinding activityPluginBinding) {
    activity = activityPluginBinding.getActivity();
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(
        "com.dynamsoft.flutter_camera_qrcode_scanner/nativeview",
        new NativeViewFactory(flutterPluginBinding.getBinaryMessenger(), activity));
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    bind(activityPluginBinding);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    bind(activityPluginBinding);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    this.flutterPluginBinding = null;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }
}
