import 'package:flutter/services.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';

enum WallpaperLocation { home, lock, both }

abstract final class WallpaperSetter {
  static const _channel = MethodChannel(AppConstants.wallpaperMethodChannel);

  static Future<bool> setFromFile(
    String filePath,
    WallpaperLocation location,
  ) async {
    try {
      final result = await _channel.invokeMethod<bool>('setWallpaper', {
        'path': filePath,
        'location': location.name,
      });
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}
