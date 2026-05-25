import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/api_constants.dart';
import 'package:wallie_4k_wallpapers/core/errors/app_exception.dart';
import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/core/network/dio_client.dart';
import 'package:wallie_4k_wallpapers/data/services/peapix_service.dart';
import 'package:wallie_4k_wallpapers/data/services/unsplash_service.dart';
import 'package:wallie_4k_wallpapers/data/services/wallhaven_service.dart';
import 'package:wallie_4k_wallpapers/domain/entities/category_entity.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';

final wallpaperRepositoryProvider = Provider<WallpaperRepository>((ref) {
  throw UnimplementedError('Override in main');
});

class WallpaperRepositoryImpl implements WallpaperRepository {
  WallpaperRepositoryImpl({
    required UnsplashService unsplash,
    required UnsplashService unsplashSearch,
    required UnsplashService unsplashDetail,
    required WallhavenService wallhaven,
    required WallhavenService wallhavenDetail,
    required PeapixService peapix,
  })  : _unsplash = unsplash,
        _unsplashSearch = unsplashSearch,
        _unsplashDetail = unsplashDetail,
        _wallhaven = wallhaven,
        _wallhavenDetail = wallhavenDetail,
        _peapix = peapix;

  final UnsplashService _unsplash;
  final UnsplashService _unsplashSearch;
  final UnsplashService _unsplashDetail;
  final WallhavenService _wallhaven;
  final WallhavenService _wallhavenDetail;
  final PeapixService _peapix;

  Future<void> _appendUnsplashForCategory({
    required List<WallpaperEntity> results,
    required CategoryEntity category,
    required int page,
  }) async {
    if (category.unsplashTopic != null) {
      try {
        final photos = await _unsplash.getTopicPhotos(
          slug: category.unsplashTopic!,
          page: page,
        );
        results.addAll(photos.map((e) => e.toEntity()));
        return;
      } on DioException {
        // Topic slug invalid or unavailable — fall back to search.
      }
    }

    try {
      final (photos, _) = await _unsplashSearch.searchPhotos(
        query: category.wallhavenQuery,
        page: page,
      );
      results.addAll(photos.map((e) => e.toEntity()));
    } on DioException {
      // Ignore; Wallhaven results may already be present.
    }
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() fn) async {
    try {
      final result = await fn();
      return Right(result);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(TimeoutFailure('Connection timed out. Please retry.'));
      } else if (e.response?.statusCode == 429) {
        return const Left(
            RateLimitFailure('Too many requests. Please wait.'));
      } else if (e.response?.statusCode == 401) {
        return const Left(AuthFailure('API key invalid or expired.'));
      } else if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure('No internet connection.'));
      }
      return const Left(
          ServerFailure('Something went wrong. Please try again.'));
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(
        kDebugMode ? 'An unexpected error occurred: $e' : 'An unexpected error occurred.',
      ));
    }
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> getTrending({int page = 1}) {
    return _guard(() async {
      if (ApiConstants.unsplashKey.isEmpty) return <WallpaperEntity>[];
      final photos = await _unsplash.getTrending(page: page);
      return photos.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> getFeaturedBanner() {
    return _guard(() async {
      final items = await _peapix.getCombinedFeatured();
      return items.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> getDailyPicks() {
    return _guard(() async {
      final items = await _peapix.getSpotlightFeed();
      return items.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> getLatest({
    int page = 1,
    String? categoryQuery,
  }) {
    return _guard(() async {
      final (items, _) = await _wallhaven.search(
        q: categoryQuery,
        sorting: 'date_added',
        page: page,
      );
      return items.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> searchWallpapers({
    required String query,
    int page = 1,
    SearchSourceFilter filter = SearchSourceFilter.all,
  }) {
    return _guard(() async {
      final results = <WallpaperEntity>[];

      if (filter == SearchSourceFilter.all ||
          filter == SearchSourceFilter.unsplash) {
        if (ApiConstants.unsplashKey.isNotEmpty) {
          try {
            final (photos, _) =
                await _unsplashSearch.searchPhotos(query: query, page: page);
            results.addAll(photos.map((e) => e.toEntity()));
          } on DioException {
            // Continue with other sources when Unsplash fails.
          }
        }
      }

      if (filter == SearchSourceFilter.all ||
          filter == SearchSourceFilter.wallhaven) {
        try {
          final (items, _) = await _wallhaven.search(q: query, page: page);
          results.addAll(items.map((e) => e.toEntity()));
        } on DioException {
          // Continue when Wallhaven fails if Unsplash already returned data.
        }
      }

      if (results.isEmpty) {
        throw const AppException('No results found for this search.');
      }

      return results;
    });
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> getCategoryWallpapers({
    required CategoryEntity category,
    int page = 1,
    CategorySort sort = CategorySort.latest,
  }) {
    return _guard(() async {
      final results = <WallpaperEntity>[];
      final sorting = switch (sort) {
        CategorySort.latest => 'date_added',
        CategorySort.popular => 'views',
        CategorySort.random => 'random',
      };

      try {
        final (whItems, _) = await _wallhaven.search(
          q: category.wallhavenQuery,
          sorting: sorting,
          page: page,
          seed: sort == CategorySort.random ? category.id : null,
        );
        results.addAll(whItems.map((e) => e.toEntity()));
      } on DioException {
        // Unsplash fallback below may still populate results.
      }

      if (ApiConstants.unsplashKey.isNotEmpty) {
        await _appendUnsplashForCategory(
          results: results,
          category: category,
          page: page,
        );
      }

      if (results.isEmpty) {
        throw const AppException('No wallpapers found for this category.');
      }

      return results;
    });
  }

  @override
  Future<Either<Failure, WallpaperEntity>> getWallpaperDetail({
    required String id,
    required String source,
  }) {
    return _guard(() async {
      if (source == 'wallhaven') {
        final whId = id.replaceFirst('wallhaven_', '');
        final item = await _wallhavenDetail.getWallpaper(whId);
        return item.toEntity();
      }
      if (source == 'unsplash') {
        final usId = id.replaceFirst('unsplash_', '');
        final photo = await _unsplashDetail.getPhoto(usId);
        return photo.toEntity();
      }
      if (source == 'peapix') {
        throw const AppException('Peapix wallpapers open from feed only.');
      }
      throw AppException('Detail not available for source: $source');
    });
  }

  @override
  Future<Either<Failure, List<WallpaperEntity>>> getRelatedWallpapers(
    WallpaperEntity wallpaper,
  ) {
    return _guard(() async {
      if (wallpaper.tags.isEmpty) {
        return getTrending(page: 1).then((r) => r.fold((l) => throw l, (v) => v));
      }
      final tag = wallpaper.tags.first;
      if (wallpaper.source == 'unsplash' &&
          ApiConstants.unsplashKey.isNotEmpty) {
        final (photos, _) = await _unsplashSearch.searchPhotos(query: tag, page: 1);
        return photos
            .map((e) => e.toEntity())
            .where((e) => e.id != wallpaper.id)
            .take(5)
            .toList();
      }
      final (items, _) = await _wallhaven.search(q: tag, page: 1);
      return items
          .map((e) => e.toEntity())
          .where((e) => e.id != wallpaper.id)
          .take(5)
          .toList();
    });
  }

  @override
  Future<Either<Failure, String>> triggerUnsplashDownload(String photoId) {
    return _guard(() async {
      final cleanId = photoId.replaceFirst('unsplash_', '');
      return _unsplashDetail.getDownloadLocation(cleanId);
    });
  }
}

Future<WallpaperRepository> createWallpaperRepository(
  CacheStore store,
) async {
  return WallpaperRepositoryImpl(
    unsplash: UnsplashService(createUnsplashDio(store)),
    unsplashSearch: UnsplashService(createUnsplashSearchDio(store)),
    unsplashDetail: UnsplashService(createUnsplashDetailDio(store)),
    wallhaven: WallhavenService(createWallhavenDio(store)),
    wallhavenDetail: WallhavenService(createWallhavenDetailDio(store)),
    peapix: PeapixService(createPeapixDio()),
  );
}
