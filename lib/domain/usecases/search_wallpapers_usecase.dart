import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';

class SearchWallpapersUsecase {
  const SearchWallpapersUsecase(this._repository);
  final WallpaperRepository _repository;

  Future<Either<Failure, List<WallpaperEntity>>> call({
    required String query,
    int page = 1,
    SearchSourceFilter filter = SearchSourceFilter.all,
  }) {
    return _repository.searchWallpapers(
      query: query,
      page: page,
      filter: filter,
    );
  }
}
