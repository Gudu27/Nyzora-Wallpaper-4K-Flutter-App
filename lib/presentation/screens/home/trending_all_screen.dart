import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/utils/infinite_scroll_listener.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/trending_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/error_state.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/pull_to_refresh_wrapper.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/staggered_grid.dart';

class TrendingAllScreen extends ConsumerStatefulWidget {
  const TrendingAllScreen({super.key});

  @override
  ConsumerState<TrendingAllScreen> createState() => _TrendingAllScreenState();
}

class _TrendingAllScreenState extends ConsumerState<TrendingAllScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final amoled = ref.watch(isAmoledProvider);
    final async = ref.watch(trendingProvider);
    final isLoadingMore = ref.watch(trendingLoadingMoreProvider);

    return Scaffold(
      backgroundColor: AppColors.appBackground(isDark, amoled: amoled),
      appBar: AppBar(
        title: Text('Trending Now', style: AppTextStyles.appBarTitle(isDark)),
        centerTitle: false,
      ),
      body: PullToRefreshWrapper(
        onRefresh: () => ref.read(trendingProvider.notifier).refresh(),
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(
            message: e is Failure ? e.message : 'Failed to load trending',
            onRetry: () => ref.invalidate(trendingProvider),
          ),
          data: (items) => InfiniteScrollListener(
            onLoadMore: () => ref.read(trendingProvider.notifier).loadMore(),
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                WallpaperStaggeredGrid(
                  wallpapers: items,
                  isLoadingMore: isLoadingMore,
                  onTap: (wp) => context.pushNamed(
                    AppRoutes.wallpaperDetail,
                    pathParameters: {'id': wp.id},
                    extra: wp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
