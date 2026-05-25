import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/domain/entities/category_entity.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';
import 'package:wallie_4k_wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/wallpaper_provider.dart';

final selectedHomeCategoryProvider = StateProvider<String?>((ref) => null);

final categorySortProvider =
    StateProvider<CategorySort>((ref) => CategorySort.latest);

final latestLoadingMoreProvider = StateProvider<bool>((ref) => false);

final latestWallpapersProvider =
    AutoDisposeAsyncNotifierProvider<LatestNotifier, List<WallpaperEntity>>(
  LatestNotifier.new,
);

class LatestNotifier extends AutoDisposeAsyncNotifier<List<WallpaperEntity>> {
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;
  final List<WallpaperEntity> _items = [];

  @override
  Future<List<WallpaperEntity>> build() async {
    ref.listen(selectedHomeCategoryProvider, (_, __) {
      _reset();
    });
    return _load();
  }

  void _reset() {
    _page = 1;
    _hasMore = true;
    _items.clear();
  }

  String? get _categoryQuery {
    final id = ref.read(selectedHomeCategoryProvider);
    if (id == null) return null;
    return CategoryEntity.all
        .firstWhere((c) => c.id == id, orElse: () => CategoryEntity.all.first)
        .wallhavenQuery;
  }

  Future<List<WallpaperEntity>> _load() async {
    final repo = ref.read(wallpaperRepositoryProvider);
    final result = await repo.getLatest(page: _page, categoryQuery: _categoryQuery);
    return result.fold((f) => throw f, (data) {
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
    if (!_hasMore || _loadingMore) return;
    _loadingMore = true;
    ref.read(latestLoadingMoreProvider.notifier).state = true;
    _page++;
    state = await AsyncValue.guard(_load);
    _loadingMore = false;
    ref.read(latestLoadingMoreProvider.notifier).state = false;
  }

  Future<void> refresh() async {
    _reset();
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final categoryLoadingMoreProvider =
    StateProvider.family<bool, String>((ref, categoryId) => false);

final categoryWallpapersProvider = AutoDisposeAsyncNotifierProviderFamily<
    CategoryWallpapersNotifier, List<WallpaperEntity>, CategoryEntity>(
  CategoryWallpapersNotifier.new,
);

class CategoryWallpapersNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<WallpaperEntity>, CategoryEntity> {
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;
  final List<WallpaperEntity> _items = [];

  @override
  Future<List<WallpaperEntity>> build(CategoryEntity arg) async {
    ref.listen(categorySortProvider, (_, __) {
      _page = 1;
      _hasMore = true;
      _items.clear();
      ref.invalidateSelf();
    });
    return _fetch(arg);
  }

  Future<List<WallpaperEntity>> _fetch(CategoryEntity category) async {
    final sort = ref.read(categorySortProvider);
    final result =
        await ref.read(getCategoryWallpapersUsecaseProvider).call(
              category: category,
              page: _page,
              sort: sort,
            );
    return result.fold((f) => throw f, (data) {
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
    if (!_hasMore || _loadingMore) return;
    _loadingMore = true;
    ref.read(categoryLoadingMoreProvider(arg.id).notifier).state = true;
    _page++;
    state = await AsyncValue.guard(() => _fetch(arg));
    _loadingMore = false;
    ref.read(categoryLoadingMoreProvider(arg.id).notifier).state = false;
  }

  Future<void> refresh() async {
    _page = 1;
    _items.clear();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(arg));
  }
}
