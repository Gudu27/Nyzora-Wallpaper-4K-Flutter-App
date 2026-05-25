import 'package:wallie_4k_wallpapers/core/constants/env.dart';

/// Resolves API keys: `--dart-define` first, then [EnvKeys] from env.dart.
abstract final class AppEnv {
  static String get unsplashKey {
    const fromDefine = String.fromEnvironment('UNSPLASH_KEY');
    if (fromDefine.isNotEmpty) return fromDefine;
    return EnvKeys.unsplashKey;
  }

  static String get wallhavenKey {
    const fromDefine = String.fromEnvironment('WALLHAVEN_KEY');
    if (fromDefine.isNotEmpty) return fromDefine;
    return EnvKeys.wallhavenKey;
  }

  static bool get hasUnsplashKey => unsplashKey.isNotEmpty;
  static bool get hasWallhavenKey => wallhavenKey.isNotEmpty;
}
