import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/wallpaper_provider.dart';

final trendingLoadingMoreProvider = StateProvider<bool>((ref) => false);

final trendingProvider =
    AutoDisposeAsyncNotifierProvider<TrendingNotifier, List<WallpaperEntity>>(
  TrendingNotifier.new,
);

class TrendingNotifier extends AutoDisposeAsyncNotifier<List<WallpaperEntity>> {
  CancelToken? _cancelToken;
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;
  final List<WallpaperEntity> _items = [];

  @override
  Future<List<WallpaperEntity>> build() async {
    ref.onDispose(() => _cancelToken?.cancel());
    _page = 1;
    _hasMore = true;
    _items.clear();
    return _fetch();
  }

  Future<List<WallpaperEntity>> _fetch() async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    final result =
        await ref.read(getTrendingUsecaseProvider).call(page: _page);
    return result.fold((failure) => throw failure, (data) {
      if (_page == 1) {
        _items
          ..clear()
          ..addAll(data);
      } else {
        _items.addAll(data);
      }
      _hasMore = data.isNotEmpty;
      return List<WallpaperEntity>.from(_items);
    });
  }

  Future<void> loadMore() async {
    if (!_hasMore || _loadingMore || state.isLoading) return;
    _loadingMore = true;
    ref.read(trendingLoadingMoreProvider.notifier).state = true;
    _page++;
    state = await AsyncValue.guard(_fetch);
    _loadingMore = false;
    ref.read(trendingLoadingMoreProvider.notifier).state = false;
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}
