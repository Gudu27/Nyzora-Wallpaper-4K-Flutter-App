import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';

class GetWallpaperDetailUsecase {
  const GetWallpaperDetailUsecase(this._repository);
  final WallpaperRepository _repository;

  Future<Either<Failure, WallpaperEntity>> call({
    required String id,
    required String source,
  }) {
    return _repository.getWallpaperDetail(id: id, source: source);
  }

  Future<Either<Failure, List<WallpaperEntity>>> related(
    WallpaperEntity wallpaper,
  ) {
    return _repository.getRelatedWallpapers(wallpaper);
  }
}
