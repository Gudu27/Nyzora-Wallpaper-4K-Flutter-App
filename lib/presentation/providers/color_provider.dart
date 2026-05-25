import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/utils/color_extractor.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/wallpaper_provider.dart';

final extractedColorProvider =
    FutureProvider.family<Color?, WallpaperEntity>((ref, wallpaper) async {
  final extractor = ref.read(colorExtractorProvider);
  if (wallpaper.dominantColorHex != null) {
    return extractor.hexToColor(wallpaper.dominantColorHex);
  }
  return extractor.extractFromUrl(wallpaper.thumbnailUrl);
});

final detailOverlaysVisibleProvider = StateProvider<bool>((ref) => true);

final relatedWallpapersProvider =
    FutureProvider.family<List<WallpaperEntity>, WallpaperEntity>(
        (ref, wallpaper) async {
  final usecase = ref.read(getWallpaperDetailUsecaseProvider);
  final result = await usecase.related(wallpaper);
  return result.fold((_) => <WallpaperEntity>[], (list) => list);
});
