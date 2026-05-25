import 'package:dio/dio.dart';
import 'package:wallie_4k_wallpapers/core/constants/api_constants.dart';
import 'package:wallie_4k_wallpapers/data/models/unsplash/unsplash_photo.dart';

class UnsplashService {
  UnsplashService(this._dio);

  final Dio _dio;

  Future<List<UnsplashPhoto>> getTrending({
    int page = 1,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/photos',
      queryParameters: {
        'page': page,
        'per_page': ApiConstants.trendingPerPage,
        'order_by': 'popular',
      },
      cancelToken: cancelToken,
    );
    return (response.data ?? [])
        .map((e) => UnsplashPhoto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<UnsplashPhoto>> getRandomFeatured({
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/photos/random',
      queryParameters: {
        'count': ApiConstants.featuredRandomCount,
        'orientation': 'portrait',
      },
      cancelToken: cancelToken,
    );
    return (response.data ?? [])
        .map((e) => UnsplashPhoto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<(List<UnsplashPhoto>, int total)> searchPhotos({
    required String query,
    int page = 1,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/search/photos',
      queryParameters: {
        'query': query,
        'page': page,
        'per_page': ApiConstants.defaultPerPage,
        'orientation': 'portrait',
      },
      cancelToken: cancelToken,
    );
    final data = response.data ?? {};
    final results = (data['results'] as List<dynamic>? ?? [])
        .map((e) => UnsplashPhoto.fromJson(e as Map<String, dynamic>))
        .toList();
    final total = data['total'] as int? ?? results.length;
    return (results, total);
  }

  Future<List<UnsplashPhoto>> getTopicPhotos({
    required String slug,
    int page = 1,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/topics/$slug/photos',
      queryParameters: {
        'page': page,
        'per_page': ApiConstants.defaultPerPage,
        'orientation': 'portrait',
      },
      cancelToken: cancelToken,
    );
    return (response.data ?? [])
        .map((e) => UnsplashPhoto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UnsplashPhoto> getPhoto(String id, {CancelToken? cancelToken}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/photos/$id',
      cancelToken: cancelToken,
    );
    return UnsplashPhoto.fromJson(response.data!);
  }

  Future<String> getDownloadLocation(
    String photoId, {
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/photos/$photoId/download',
      cancelToken: cancelToken,
    );
    return response.data?['url'] as String? ?? '';
  }
}
