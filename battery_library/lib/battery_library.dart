import 'dart:async';

import 'package:flutter/services.dart';

class BatteryLibrary {
  static const MethodChannel _channel = const MethodChannel('battery_library');

  static Future<int> get batteryLevel async {
    final int batteryLevel = await _channel.invokeMethod('getBatteryLevel');
    return batteryLevel;
  }

  static Future<int> get batteryState async {
    final int batteryState = await _channel.invokeMethod('getBatteryState');
    return batteryState;
  }
}
