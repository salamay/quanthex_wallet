import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quanthex/data/repository/secure_storage.dart';


class DeviceUtils{


  static Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique ID for Android
    } else if (Platform.isIOS) {
      return SecureStorage.getInstance().getOrCreate();
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsDeviceInfo = await deviceInfo.macOsInfo;
      return macOsDeviceInfo.systemGUID; // Unique ID for MACOS
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsDeviceInfo = await deviceInfo.windowsInfo;
      return windowsDeviceInfo.deviceId; // Unique ID for WINDOW
    }
    return null; // Return null for other platforms
  }

  static String getDeviceType()  {
    if (Platform.isAndroid) {
      print("Running on Android");
      return "ANDROID";
    } else if (Platform.isIOS) {
      print("Running on iOS");
      return "IOS";
    } else if (Platform.isMacOS) {
      print("Running on macOS");
      return "MACOS";
    } else if (Platform.isWindows) {
      print("Running on Windows");
      return "WINDOWS";
    } else if (Platform.isLinux) {
      print("Running on Linux");
      return "LINUX";
    } else if (Platform.isFuchsia) {
      print("Running on Fuchsia");
      return "FUCHSIA";
    } else {
      print("Unknown platform");
      return "UNKNOWN";
    }
  }

  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    print("App name: ${info.appName}");
    print("Package name: ${info.packageName}");
    print("Version: ${info.version}");
    print("Build number: ${info.buildNumber}");
    return "Version: ${info.version}+${info.buildNumber}";
  }
}