import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/domain/entities/category_entity.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';

enum SearchSourceFilter { all, unsplash, wallhaven }

enum CategorySort { latest, popular, random }

abstract class WallpaperRepository {
  Future<Either<Failure, List<WallpaperEntity>>> getTrending({int page = 1});
  Future<Either<Failure, List<WallpaperEntity>>> getFeaturedBanner();
  Future<Either<Failure, List<WallpaperEntity>>> getDailyPicks();
  Future<Either<Failure, List<WallpaperEntity>>> getLatest({
    int page = 1,
    String? categoryQuery,
  });
  Future<Either<Failure, List<WallpaperEntity>>> searchWallpapers({
    required String query,
    int page = 1,
    SearchSourceFilter filter = SearchSourceFilter.all,
  });
  Future<Either<Failure, List<WallpaperEntity>>> getCategoryWallpapers({
    required CategoryEntity category,
    int page = 1,
    CategorySort sort = CategorySort.latest,
  });
  Future<Either<Failure, WallpaperEntity>> getWallpaperDetail({
    required String id,
    required String source,
  });
  Future<Either<Failure, List<WallpaperEntity>>> getRelatedWallpapers(
    WallpaperEntity wallpaper,
  );
  Future<Either<Failure, String>> triggerUnsplashDownload(String photoId);
}
