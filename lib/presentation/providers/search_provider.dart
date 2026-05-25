import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/wallpaper_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchSourceFilterProvider =
    StateProvider<SearchSourceFilter>((ref) => SearchSourceFilter.all);

final recentSearchesProvider =
    StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
  return RecentSearchesNotifier();
});

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier() : super([]) {
    _load();
  }

  Box<String>? _box;

  Future<void> _load() async {
    _box = await Hive.openBox<String>(AppConstants.hiveRecentSearchesBox);
    state = _box!.values.toList().reversed.toList();
  }

  Future<void> addSearch(String query) async {
    if (query.trim().isEmpty) return;
    _box ??= await Hive.openBox<String>(AppConstants.hiveRecentSearchesBox);
    final trimmed = query.trim();
    final existing = state.where((e) => e != trimmed).toList();
    final updated = [trimmed, ...existing].take(AppConstants.maxRecentSearches).toList();
    await _box!.clear();
    for (var i = 0; i < updated.length; i++) {
      await _box!.put(i.toString(), updated[i]);
    }
    state = updated;
  }

  Future<void> removeSearch(String query) async {
    _box ??= await Hive.openBox<String>(AppConstants.hiveRecentSearchesBox);
    final updated = state.where((e) => e != query).toList();
    await _box!.clear();
    for (var i = 0; i < updated.length; i++) {
      await _box!.put(i.toString(), updated[i]);
    }
    state = updated;
  }

  Future<void> clearAll() async {
    _box ??= await Hive.openBox<String>(AppConstants.hiveRecentSearchesBox);
    await _box!.clear();
    state = [];
  }
}

final searchLoadingMoreProvider = StateProvider.family<bool, String>((ref, _) => false);

final searchResultsProvider = AutoDisposeAsyncNotifierProviderFamily<
    SearchResultsNotifier, List<WallpaperEntity>, String>(
  SearchResultsNotifier.new,
);

class SearchResultsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<WallpaperEntity>, String> {
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;
  final List<WallpaperEntity> _items = [];

  @override
  Future<List<WallpaperEntity>> build(String arg) async {
    if (arg.isEmpty) return [];
    _page = 1;
    _hasMore = true;
    _items.clear();
    return _fetch();
  }

  Future<List<WallpaperEntity>> _fetch() async {
    final filter = ref.read(searchSourceFilterProvider);
    final result = await ref.read(searchWallpapersUsecaseProvider).call(
          query: arg,
          page: _page,
          filter: filter,
        );
    return result.fold((f) => throw f, (data) {
      if (_page == 1) {
        _items
          ..clear()
          ..addAll(data);
      } else {
        _items.addAll(data);
      }
      _hasMore = data.length >= 20;
      return List<WallpaperEntity>.from(_items);
    });
  }

  Future<void> loadMore() async {
    if (!_hasMore || _loadingMore || state.isLoading) return;
    _loadingMore = true;
    ref.read(searchLoadingMoreProvider(arg).notifier).state = true;
    _page++;
    state = await AsyncValue.guard(_fetch);
    _loadingMore = false;
    ref.read(searchLoadingMoreProvider(arg).notifier).state = false;
  }

  Future<void> refresh() async {
    _page = 1;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

enum DownloadState { idle, loading, success, error }
