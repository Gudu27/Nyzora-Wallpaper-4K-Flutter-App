import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.g.dart';

final favoritesBoxProvider = Provider<Box<WallpaperEntity>>((ref) {
  throw UnimplementedError('Override in main');
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<WallpaperEntity>>((ref) {
  return FavoritesNotifier(ref.watch(favoritesBoxProvider));
});

class FavoritesNotifier extends StateNotifier<List<WallpaperEntity>> {
  FavoritesNotifier(this._box) : super(_loadFromBox(_box));

  final Box<WallpaperEntity> _box;

  static List<WallpaperEntity> _loadFromBox(Box<WallpaperEntity> box) {
    return box.values.toList();
  }

  bool isFavorite(WallpaperEntity wallpaper) {
    return state.any((w) => w.id == wallpaper.id && w.source == wallpaper.source);
  }

  Future<void> toggle(WallpaperEntity wallpaper) async {
    final key = '${wallpaper.source}_${wallpaper.id}';
    if (isFavorite(wallpaper)) {
      await _box.delete(key);
      state = state.where((w) => w.id != wallpaper.id).toList();
    } else {
      await _box.put(key, wallpaper);
      state = [...state, wallpaper];
    }
  }

  Future<void> remove(WallpaperEntity wallpaper) async {
    final key = '${wallpaper.source}_${wallpaper.id}';
    await _box.delete(key);
    state = state.where((w) => w.id != wallpaper.id).toList();
  }

  Future<void> refresh() async {
    state = _loadFromBox(_box);
  }
}

final isFavoriteProvider = Provider.family<bool, WallpaperEntity>((ref, wp) {
  return ref.watch(favoritesProvider).any(
        (w) => w.id == wp.id && w.source == wp.source,
      );
});
