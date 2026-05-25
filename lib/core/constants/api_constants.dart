import 'package:wallie_4k_wallpapers/core/constants/app_env.dart';

abstract final class ApiConstants {
  static String get unsplashKey => AppEnv.unsplashKey;
  static String get wallhavenKey => AppEnv.wallhavenKey;

  static const String unsplashBaseUrl = 'https://api.unsplash.com';
  static const String wallhavenBaseUrl = 'https://wallhaven.cc/api/v1';
  static const String peapixBingFeed =
      'https://peapix.com/bing/feed?country=in&n=10';
  static const String peapixSpotlightFeed =
      'https://peapix.com/spotlight/feed?n=10';

  static const String unsplashAcceptVersion = 'v1';
  static const String appUtmSource = 'wallie_4k_wallpapers';

  static const int defaultPerPage = 20;
  static const int trendingPerPage = 15;
  static const int featuredRandomCount = 10;

  /// Wallhaven — purity=100 is hardcoded, never configurable.
  static const String wallhavenPurity = '100';
  static const String wallhavenRatios = 'portrait';
  static const String wallhavenMinResolution = '1080x1920';

  static const Duration listCacheDuration = Duration(minutes: 30);
  static const Duration searchCacheDuration = Duration(minutes: 5);
  static const Duration detailCacheDuration = Duration(minutes: 60);
  static const int maxCacheSizeMb = 50;
}
