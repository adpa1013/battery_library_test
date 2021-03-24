import Cocoa
import FlutterMacOS
import Foundation
import IOKit.ps

public class BatteryLibraryPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "battery_library", binaryMessenger: registrar.messenger)
    let instance = BatteryLibraryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // Take a snapshot of all the power source info
    let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()

    // Pull out a list of power sources
    let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array

    // For each power source...
    for ps in sources {
      // Fetch the information for a given power source out of our snapshot
      let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]

      // Pull out the name and capacity
      if let name = info[kIOPSNameKey] as? String,
        let capacity = info[kIOPSCurrentCapacityKey] as? Int,
        let max = info[kIOPSMaxCapacityKey] as? Int {
        result(String(capacity))
      }
    }
  }
}
