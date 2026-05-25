import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:wallie_4k_wallpapers/core/constants/api_constants.dart';

Future<CacheOptions> buildCacheOptions({
  required CachePolicy policy,
  Duration maxStale = ApiConstants.listCacheDuration,
}) async {
  final store = MemCacheStore();

  return CacheOptions(
    store: store,
    policy: policy,
    maxStale: maxStale,
    hitCacheOnErrorExcept: [401, 403],
    priority: CachePriority.normal,
  );
}

CacheOptions listCacheOptions(CacheStore store) => CacheOptions(
      store: store,
      policy: CachePolicy.request,
      maxStale: ApiConstants.listCacheDuration,
      hitCacheOnErrorExcept: [401, 403],
    );

CacheOptions searchCacheOptions(CacheStore store) => CacheOptions(
      store: store,
      policy: CachePolicy.request,
      maxStale: ApiConstants.searchCacheDuration,
      hitCacheOnErrorExcept: [401, 403],
    );

CacheOptions detailCacheOptions(CacheStore store) => CacheOptions(
      store: store,
      policy: CachePolicy.request,
      maxStale: ApiConstants.detailCacheDuration,
      hitCacheOnErrorExcept: [401, 403],
    );
