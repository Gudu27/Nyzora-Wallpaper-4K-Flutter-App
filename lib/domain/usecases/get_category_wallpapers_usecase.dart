import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/domain/entities/category_entity.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';

class GetCategoryWallpapersUsecase {
  const GetCategoryWallpapersUsecase(this._repository);
  final WallpaperRepository _repository;

  Future<Either<Failure, List<WallpaperEntity>>> call({
    required CategoryEntity category,
    int page = 1,
    CategorySort sort = CategorySort.latest,
  }) {
    return _repository.getCategoryWallpapers(
      category: category,
      page: page,
      sort: sort,
    );
  }
}
