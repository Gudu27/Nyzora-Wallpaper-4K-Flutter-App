import 'package:flutter/services.dart';

enum WallpaperLocation { home, lock, both }

abstract final class WallpaperSetter {
  static const _channel = MethodChannel('com.wallie.wallpapers/wallpaper');

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
