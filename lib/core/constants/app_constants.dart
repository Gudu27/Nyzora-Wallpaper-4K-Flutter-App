abstract final class AppConstants {
  static const String appName = 'Nyzora Wallpaper 4K';
  static const String appTagline = 'Walls That Speak';
  static const String packageName = 'com.nyzora.wallpaper';

  /// Android MethodChannel for setting device wallpaper.
  static const String wallpaperMethodChannel =
      'com.nyzora.wallpaper/wallpaper';

  /// Deep link scheme: nyzora://wallpaper/...
  static const String deepLinkScheme = 'nyzora';
  static const String deepLinkHost = 'wallpaper';

  static const String hiveFavoritesBox = 'favorites_box';
  static const String hiveRecentSearchesBox = 'recent_searches_box';
  static const String hiveWallpaperTypeId = 'wallpaper_entity';

  static const String prefFirstLaunch = 'first_launch';
  static const String prefDarkMode = 'dark_mode';
  static const String prefAmoledMode = 'amoled_mode';
  static const String prefDownloadQuality = 'download_quality';

  static const int maxRecentSearches = 10;
  static const int scrollToTopThreshold = 400;
  static const int infiniteScrollItemsFromEnd = 3;
  static const int carouselAutoScrollSeconds = 4;

  static const String privacyPolicyUrl =
      'https://www.example.com/privacy-policy';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.nyzora.wallpaper';

  static const List<String> trendingSearchTags = [
    'space',
    'nature',
    'dark',
    'neon',
    'city',
    'abstract',
    'mountains',
    'ocean',
    'minimal',
    'anime',
    'flowers',
    'cars',
  ];

  static const String downloadFolderName = 'NyzoraWallpaper4K';

  static const List<String> downloadQualityOptions = [
    'HD 720p',
    'Full HD 1080p',
    '4K',
  ];
}
