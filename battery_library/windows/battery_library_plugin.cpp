#include "include/battery_library/battery_library_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>
#include <map>
#include <memory>
#include <sstream>
#include <string.h>
#include <iostream>

namespace
{

  class BatteryLibraryPlugin : public flutter::Plugin
  {
  public:
    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

    BatteryLibraryPlugin();

    virtual ~BatteryLibraryPlugin();

  private:
    // Called when a method is called on this plugin's channel from Dart.
    void HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  };

  // static
  void BatteryLibraryPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarWindows *registrar)
  {
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "battery_library",
            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<BatteryLibraryPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result) {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  BatteryLibraryPlugin::BatteryLibraryPlugin() {}

  BatteryLibraryPlugin::~BatteryLibraryPlugin() {}

  void BatteryLibraryPlugin::HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    if (method_call.method_name().compare("getBatteryLevel") == 0)
    {
      SYSTEM_POWER_STATUS spsPwr;
      if (GetSystemPowerStatus(&spsPwr))
      {
        int batterylevel = static_cast<int>(spsPwr.BatteryLifePercent);
        result->Success(flutter::EncodableValue(batterylevel));
      }
    }
    else
    {
      if (method_call.method_name().compare("getBatteryState") == 0)
      {
        SYSTEM_POWER_STATUS spsPwr;
        if (GetSystemPowerStatus(&spsPwr))
        {
          int battery_state = (static_cast<int>(spsPwr.ACLineStatus));
          switch (battery_state)
          {
          //charging
          case 1:
            if (static_cast<int>(spsPwr.BatteryLifePercent) == 100)
            {
              result->Success(flutter::EncodableValue(4));
            }
            else
            {
              result->Success(flutter::EncodableValue(2));
            }
            break;

          //discharging
          case 0:
            result->Success(flutter::EncodableValue(3));
            break;
          //unknown
          default:
            result->Success(flutter::EncodableValue(5));
            break;
          }
        }
        result->NotImplemented();
      }
    }
  }
}

void BatteryLibraryPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar)
{
  BatteryLibraryPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}