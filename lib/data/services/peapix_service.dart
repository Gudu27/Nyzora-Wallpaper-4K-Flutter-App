import 'package:dio/dio.dart';
import 'package:wallie_4k_wallpapers/core/constants/api_constants.dart';
import 'package:wallie_4k_wallpapers/data/models/peapix/peapix_image.dart';

class PeapixService {
  PeapixService(this._dio);

  final Dio _dio;

  Future<List<PeapixImage>> getBingFeed({CancelToken? cancelToken}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.peapixBingFeed,
      cancelToken: cancelToken,
    );
    return _parseFeed(response.data, 'bing');
  }

  Future<List<PeapixImage>> getSpotlightFeed({
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.peapixSpotlightFeed,
      cancelToken: cancelToken,
    );
    return _parseFeed(response.data, 'spotlight');
  }

  Future<List<PeapixImage>> getCombinedFeatured({
    CancelToken? cancelToken,
  }) async {
    final results = await Future.wait([
      getBingFeed(cancelToken: cancelToken),
      getSpotlightFeed(cancelToken: cancelToken),
    ]);
    return [...results[0], ...results[1]];
  }

  List<PeapixImage> _parseFeed(dynamic data, String feedType) {
    if (data is List) {
      return data
          .map((e) => PeapixImage.fromJson(e as Map<String, dynamic>, feedType))
          .where((e) => PeapixImage.hasValidUrl(e.imageUrl))
          .toList();
    }
    if (data is Map<String, dynamic>) {
      final items = data['items'] as List<dynamic>? ??
          data['data'] as List<dynamic>? ??
          data['images'] as List<dynamic>?;
      if (items != null) {
        return items
            .map((e) =>
                PeapixImage.fromJson(e as Map<String, dynamic>, feedType))
            .where((e) => PeapixImage.hasValidUrl(e.imageUrl))
            .toList();
      }
      final single = PeapixImage.fromJson(data, feedType);
      return PeapixImage.hasValidUrl(single.imageUrl) ? [single] : [];
    }
    return [];
  }
}
