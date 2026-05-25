import 'package:flutter_test/flutter_test.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';

void main() {
  test('App constants are defined', () {
    expect(AppConstants.appName, 'Nyzora Wallpaper 4K');
    expect(AppConstants.packageName, 'com.nyzora.wallpaper');
    expect(AppConstants.appTagline, isNotEmpty);
  });
}
