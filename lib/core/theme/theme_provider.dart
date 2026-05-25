import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main');
});

class ThemeSettings {
  const ThemeSettings({
    required this.isDark,
    required this.amoled,
    required this.downloadQualityIndex,
  });

  final bool isDark;
  final bool amoled;
  final int downloadQualityIndex;

  ThemeSettings copyWith({
    bool? isDark,
    bool? amoled,
    int? downloadQualityIndex,
  }) {
    return ThemeSettings(
      isDark: isDark ?? this.isDark,
      amoled: amoled ?? this.amoled,
      downloadQualityIndex:
          downloadQualityIndex ?? this.downloadQualityIndex,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeSettings> {
  ThemeNotifier(this._prefs)
      : super(
          ThemeSettings(
            isDark: _prefs.getBool(AppConstants.prefDarkMode) ?? true,
            amoled: _prefs.getBool(AppConstants.prefAmoledMode) ?? true,
            downloadQualityIndex:
                _prefs.getInt(AppConstants.prefDownloadQuality) ?? 1,
          ),
        );

  final SharedPreferences _prefs;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(AppConstants.prefDarkMode, value);
    state = state.copyWith(isDark: value);
  }

  Future<void> setAmoledMode(bool value) async {
    await _prefs.setBool(AppConstants.prefAmoledMode, value);
    state = state.copyWith(amoled: value);
  }

  Future<void> setDownloadQuality(int index) async {
    await _prefs.setInt(AppConstants.prefDownloadQuality, index);
    state = state.copyWith(downloadQualityIndex: index);
  }
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeProvider).isDark;
});

final isAmoledProvider = Provider<bool>((ref) {
  return ref.watch(themeProvider).amoled;
});
