import 'package:dio/dio.dart';
import 'package:wallie_4k_wallpapers/core/constants/api_constants.dart';
import 'package:wallie_4k_wallpapers/data/models/wallhaven/wallhaven_meta.dart';
import 'package:wallie_4k_wallpapers/data/models/wallhaven/wallhaven_wallpaper.dart';

class WallhavenService {
  WallhavenService(this._dio);

  final Dio _dio;

  Map<String, dynamic> _baseQuery({
    String? q,
    String sorting = 'date_added',
    int page = 1,
    String? seed,
    String categories = '111',
  }) {
    return {
      'purity': ApiConstants.wallhavenPurity,
      'ratios': ApiConstants.wallhavenRatios,
      'atleast': ApiConstants.wallhavenMinResolution,
      'page': page,
      'sorting': sorting,
      'categories': categories,
      if (q != null && q.isNotEmpty) 'q': q,
      if (seed != null) 'seed': seed,
    };
  }

  Future<(List<WallhavenWallpaper>, WallhavenMeta)> search({
    String? q,
    String sorting = 'date_added',
    int page = 1,
    String? seed,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/search',
      queryParameters: _baseQuery(
        q: q,
        sorting: sorting,
        page: page,
        seed: seed,
      ),
      cancelToken: cancelToken,
    );
    final data = response.data ?? {};
    final items = (data['data'] as List<dynamic>? ?? [])
        .map((e) => WallhavenWallpaper.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = WallhavenMeta.fromJson(
      data['meta'] as Map<String, dynamic>? ?? {},
    );
    return (items, meta);
  }

  Future<WallhavenWallpaper> getWallpaper(
    String id, {
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/w/$id',
      cancelToken: cancelToken,
    );
    return WallhavenWallpaper.fromJson(response.data ?? {});
  }
}
