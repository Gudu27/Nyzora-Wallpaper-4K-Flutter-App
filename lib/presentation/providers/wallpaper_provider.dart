import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';
import 'package:wallie_4k_wallpapers/domain/usecases/get_category_wallpapers_usecase.dart';
import 'package:wallie_4k_wallpapers/domain/usecases/get_daily_picks_usecase.dart';
import 'package:wallie_4k_wallpapers/domain/usecases/get_featured_usecase.dart';
import 'package:wallie_4k_wallpapers/domain/usecases/get_trending_usecase.dart';
import 'package:wallie_4k_wallpapers/domain/usecases/get_wallpaper_detail_usecase.dart';
import 'package:wallie_4k_wallpapers/domain/usecases/search_wallpapers_usecase.dart';

final getTrendingUsecaseProvider = Provider<GetTrendingUsecase>((ref) {
  return GetTrendingUsecase(ref.watch(wallpaperRepositoryProvider));
});

final getFeaturedUsecaseProvider = Provider<GetFeaturedUsecase>((ref) {
  return GetFeaturedUsecase(ref.watch(wallpaperRepositoryProvider));
});

final getDailyPicksUsecaseProvider = Provider<GetDailyPicksUsecase>((ref) {
  return GetDailyPicksUsecase(ref.watch(wallpaperRepositoryProvider));
});

final getCategoryWallpapersUsecaseProvider =
    Provider<GetCategoryWallpapersUsecase>((ref) {
  return GetCategoryWallpapersUsecase(ref.watch(wallpaperRepositoryProvider));
});

final searchWallpapersUsecaseProvider = Provider<SearchWallpapersUsecase>((ref) {
  return SearchWallpapersUsecase(ref.watch(wallpaperRepositoryProvider));
});

final getWallpaperDetailUsecaseProvider =
    Provider<GetWallpaperDetailUsecase>((ref) {
  return GetWallpaperDetailUsecase(ref.watch(wallpaperRepositoryProvider));
});
