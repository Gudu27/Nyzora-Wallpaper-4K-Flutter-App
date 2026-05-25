// Play Store checklist — before submission:
// ✅ Privacy Policy URL hosted (settings → Privacy Policy)
// ✅ App icon 512x512 PNG (flutter_launcher_icons)
// ✅ Screenshots 1080x1920 from real device
// ✅ targetSdk 35, AAB release build with dart-define API keys
// ✅ Closed testing 14 days / 12 testers (new Play accounts)
// ✅ purity=100 hardcoded in all Wallhaven API calls
// ✅ Unsplash photographer attribution on detail screen

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallie_4k_wallpapers/app.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:wallie_4k_wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.g.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/favorites_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  await Hive.initFlutter();
  Hive.registerAdapter(WallpaperEntityAdapter());

  final prefs = await SharedPreferences.getInstance();
  final favoritesBox =
      await Hive.openBox<WallpaperEntity>(AppConstants.hiveFavoritesBox);

  final cacheStore = MemCacheStore();
  final repository = await createWallpaperRepository(cacheStore);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        favoritesBoxProvider.overrideWithValue(favoritesBox),
        wallpaperRepositoryProvider.overrideWithValue(repository),
      ],
      child: const NyzoraApp(),
    ),
  );
}
