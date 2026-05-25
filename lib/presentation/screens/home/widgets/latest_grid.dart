import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/category_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/error_state.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/section_header.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/staggered_grid.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/wallpaper_card_shimmer.dart';

class LatestGrid extends ConsumerWidget {
  const LatestGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(latestWallpapersProvider);
    final isLoadingMore = ref.watch(latestLoadingMoreProvider);

    return Column(
      children: [
        const SectionHeader(title: 'Latest'),
        async.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: WallpaperCardShimmer()),
                SizedBox(width: 8),
                Expanded(child: WallpaperCardShimmer()),
              ],
            ),
          ),
          error: (e, _) => ErrorState(
            message: e is Failure ? e.message : 'Failed to load',
            onRetry: () => ref.invalidate(latestWallpapersProvider),
          ),
          data: (items) => WallpaperStaggeredGrid(
            wallpapers: items,
            isLoadingMore: isLoadingMore,
            onTap: (wp) => context.pushNamed(
              AppRoutes.wallpaperDetail,
              pathParameters: {'id': wp.id},
              extra: wp,
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
