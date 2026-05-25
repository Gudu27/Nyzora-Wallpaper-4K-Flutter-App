import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/wallpaper_provider.dart';

final trendingProvider =
    AutoDisposeAsyncNotifierProvider<TrendingNotifier, List<WallpaperEntity>>(
  TrendingNotifier.new,
);

class TrendingNotifier extends AutoDisposeAsyncNotifier<List<WallpaperEntity>> {
  CancelToken? _cancelToken;

  @override
  Future<List<WallpaperEntity>> build() async {
    ref.onDispose(() => _cancelToken?.cancel());
    _cancelToken = CancelToken();
    final usecase = ref.read(getTrendingUsecaseProvider);
    final result = await usecase.call(page: 1);
    return result.fold(
      (failure) => throw failure,
      (data) => data,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      _cancelToken?.cancel();
      _cancelToken = CancelToken();
      final result = await ref.read(getTrendingUsecaseProvider).call(page: 1);
      return result.fold((f) => throw f, (d) => d);
    });
  }
}
