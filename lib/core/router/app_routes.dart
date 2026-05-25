/// Named route constants for GoRouter deep linking.
abstract final class AppRoutes {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String noInternet = 'noInternet';
  static const String home = 'home';
  static const String search = 'search';
  static const String categories = 'categories';
  static const String favorites = 'favorites';
  static const String categoryDetail = 'categoryDetail';
  static const String wallpaperDetail = 'wallpaperDetail';
  static const String trendingAll = 'trendingAll';
  static const String settings = 'settings';
  static const String webview = 'webview';

  static const String splashPath = '/';
  static const String onboardingPath = '/onboarding';
  static const String noInternetPath = '/no-internet';
  static const String homePath = '/home';
  static const String searchPath = '/search';
  static const String categoriesPath = '/categories';
  static const String favoritesPath = '/favorites';
  static const String trendingAllPath = '/trending';
  static const String settingsPath = '/settings';
  static const String webviewPath = '/webview';

  static String categoryPath(String id) => '/category/$id';
  static String detailPath(String id) => '/detail/$id';
}
