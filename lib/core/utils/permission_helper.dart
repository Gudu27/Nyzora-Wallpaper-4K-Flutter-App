import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

abstract final class PermissionHelper {
  /// Android 10+ saves downloads via MediaStore without READ_MEDIA_* permissions.
  /// iOS still needs Photos access to save to the gallery.
  static Future<bool> requestStoragePermission() async {
    if (kIsWeb) return true;

    if (defaultTargetPlatform == TargetPlatform.android) {
      return true;
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
      return true;
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
