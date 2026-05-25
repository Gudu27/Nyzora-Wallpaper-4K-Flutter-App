abstract final class AppConstants {
  static const String appName = 'Wallie 4K Wallpapers';
  static const String appTagline = 'Walls That Speak';
  static const String packageName = 'com.wallie.wallpapers';

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
      'https://play.google.com/store/apps/details?id=com.wallie.wallpapers';

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

  static const String downloadFolderName = 'Wallie4KWallpapers';

  static const List<String> downloadQualityOptions = [
    'HD 720p',
    'Full HD 1080p',
    '4K',
  ];
}
