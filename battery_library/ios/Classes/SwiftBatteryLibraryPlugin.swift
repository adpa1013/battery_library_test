import Flutter
import UIKit

public class SwiftBatteryLibraryPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "battery_library", binaryMessenger: registrar.messenger())
    let instance = SwiftBatteryLibraryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    switch call.method {
    case "getBatteryLevel":
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
          result(-1)
        } else {
        result(Int(device.batteryLevel * 100))
        }
    case "getBatteryState":
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
          result(-a)
        } else {
          result(device.batteryState) // 2 => Charging
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
