import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';

class GetTrendingUsecase {
  const GetTrendingUsecase(this._repository);
  final WallpaperRepository _repository;

  Future<Either<Failure, List<WallpaperEntity>>> call({int page = 1}) {
    return _repository.getTrending(page: page);
  }
}
