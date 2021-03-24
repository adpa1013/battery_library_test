#import "BatteryLibraryPlugin.h"
#if __has_include(<battery_library/battery_library-Swift.h>)
#import <battery_library/battery_library-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "battery_library-Swift.h"
#endif

@implementation BatteryLibraryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBatteryLibraryPlugin registerWithRegistrar:registrar];
}
@end
