import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/wallpaper_provider.dart';

final featuredProvider =
    AutoDisposeAsyncNotifierProvider<FeaturedNotifier, List<WallpaperEntity>>(
  FeaturedNotifier.new,
);

class FeaturedNotifier extends AutoDisposeAsyncNotifier<List<WallpaperEntity>> {
  @override
  Future<List<WallpaperEntity>> build() async {
    final result = await ref.read(getFeaturedUsecaseProvider).call();
    return result.fold((f) => throw f, (d) => d);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(getFeaturedUsecaseProvider).call();
      return result.fold((f) => throw f, (d) => d);
    });
  }
}

final dailyPicksProvider =
    AutoDisposeAsyncNotifierProvider<DailyPicksNotifier, List<WallpaperEntity>>(
  DailyPicksNotifier.new,
);

class DailyPicksNotifier extends AutoDisposeAsyncNotifier<List<WallpaperEntity>> {
  @override
  Future<List<WallpaperEntity>> build() async {
    final result = await ref.read(getDailyPicksUsecaseProvider).call();
    return result.fold((f) => throw f, (d) => d);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(getDailyPicksUsecaseProvider).call();
      return result.fold((f) => throw f, (d) => d);
    });
  }
}
