import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/api_constants.dart';
import 'package:wallie_4k_wallpapers/core/network/cache_interceptor.dart';

final cacheStoreProvider = Provider<CacheStore>((ref) {
  return MemCacheStore();
});

final dioProvider = Provider<Dio>((ref) {
  final store = ref.watch(cacheStoreProvider);
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  final cacheOptions = CacheOptions(
    store: store,
    policy: CachePolicy.request,
    maxStale: ApiConstants.listCacheDuration,
    hitCacheOnErrorExcept: [401, 403],
  );

  dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  return dio;
});

Dio createServiceDio({
  required String baseUrl,
  Map<String, String>? headers,
  CacheStore? store,
  CacheOptions? cacheOptions,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  if (store != null && cacheOptions != null) {
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  return dio;
}

Dio createUnsplashDio(CacheStore store) {
  return createServiceDio(
    baseUrl: ApiConstants.unsplashBaseUrl,
    headers: {
      'Authorization': 'Client-ID ${ApiConstants.unsplashKey}',
      'Accept-Version': ApiConstants.unsplashAcceptVersion,
    },
    store: store,
    cacheOptions: listCacheOptions(store),
  );
}

Dio createWallhavenDio(CacheStore store) {
  return createServiceDio(
    baseUrl: ApiConstants.wallhavenBaseUrl,
    headers: {
      if (ApiConstants.wallhavenKey.isNotEmpty)
        'X-API-Key': ApiConstants.wallhavenKey,
    },
    store: store,
    cacheOptions: listCacheOptions(store),
  );
}

Dio createUnsplashSearchDio(CacheStore store) {
  return createServiceDio(
    baseUrl: ApiConstants.unsplashBaseUrl,
    headers: {
      'Authorization': 'Client-ID ${ApiConstants.unsplashKey}',
      'Accept-Version': ApiConstants.unsplashAcceptVersion,
    },
    store: store,
    cacheOptions: searchCacheOptions(store),
  );
}

Dio createUnsplashDetailDio(CacheStore store) {
  return createServiceDio(
    baseUrl: ApiConstants.unsplashBaseUrl,
    headers: {
      'Authorization': 'Client-ID ${ApiConstants.unsplashKey}',
      'Accept-Version': ApiConstants.unsplashAcceptVersion,
    },
    store: store,
    cacheOptions: detailCacheOptions(store),
  );
}

Dio createWallhavenDetailDio(CacheStore store) {
  return createServiceDio(
    baseUrl: ApiConstants.wallhavenBaseUrl,
    headers: {
      if (ApiConstants.wallhavenKey.isNotEmpty)
        'X-API-Key': ApiConstants.wallhavenKey,
    },
    store: store,
    cacheOptions: detailCacheOptions(store),
  );
}

Dio createPeapixDio() {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
}
