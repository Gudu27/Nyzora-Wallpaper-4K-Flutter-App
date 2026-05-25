import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';

class GetFeaturedUsecase {
  const GetFeaturedUsecase(this._repository);
  final WallpaperRepository _repository;

  Future<Either<Failure, List<WallpaperEntity>>> call() {
    return _repository.getFeaturedBanner();
  }
}
