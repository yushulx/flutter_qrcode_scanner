package com.dynamsoft.flutter_qrcode_scanner;

import android.content.Context;
import android.view.View;
import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;
import android.app.Activity;

class NativeViewFactory extends PlatformViewFactory {
  @NonNull private final BinaryMessenger messenger;
  @NonNull private Activity activity;

  NativeViewFactory(@NonNull BinaryMessenger messenger, Activity activity) {
    super(StandardMessageCodec.INSTANCE);
    this.messenger = messenger;
    this.activity = activity;
  }

  @NonNull
  @Override
  public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
    final Map<String, Object> creationParams = (Map<String, Object>) args;
    return new NativeView(messenger, activity, id, creationParams);
  }
}