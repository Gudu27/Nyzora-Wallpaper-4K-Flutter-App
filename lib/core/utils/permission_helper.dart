import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

abstract final class PermissionHelper {
  static Future<bool> requestStoragePermission() async {
    if (kIsWeb) return true;

    if (defaultTargetPlatform == TargetPlatform.android) {
      final info = await DeviceInfoPlugin().androidInfo;
      final sdk = info.version.sdkInt;

      if (sdk >= 33) {
        final status = await Permission.photos.request();
        return status.isGranted || status.isLimited;
      } else if (sdk >= 29) {
        final status = await Permission.storage.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final status = await Permission.photos.request();
      return status.isGranted || status.isLimited;
    }

    return true;
  }

  static Future<bool> hasStoragePermission() async {
    if (kIsWeb) return true;

    if (defaultTargetPlatform == TargetPlatform.android) {
      final info = await DeviceInfoPlugin().androidInfo;
      final sdk = info.version.sdkInt;

      if (sdk >= 33) {
        return await Permission.photos.isGranted ||
            await Permission.photos.isLimited;
      }
      return await Permission.storage.isGranted;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await Permission.photos.isGranted ||
          await Permission.photos.isLimited;
    }

    return true;
  }

  static Future<bool> openAppSettingsIfDenied() async {
    return openAppSettings();
  }
}
