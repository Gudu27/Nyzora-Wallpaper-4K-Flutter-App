import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/domain/entities/category_entity.dart';
import 'package:wallie_4k_wallpapers/domain/repositories/wallpaper_repository.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/category_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/error_state.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/pull_to_refresh_wrapper.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/scroll_to_top_button.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/utils/infinite_scroll_listener.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/staggered_grid.dart';

class CategoryDetailScreen extends ConsumerStatefulWidget {
  const CategoryDetailScreen({super.key, required this.category});

  final CategoryEntity category;

  @override
  ConsumerState<CategoryDetailScreen> createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final sort = ref.watch(categorySortProvider);
    final async = ref.watch(categoryWallpapersProvider(widget.category));
    final isLoadingMore =
        ref.watch(categoryLoadingMoreProvider(widget.category.id));

    return Scaffold(
      backgroundColor: AppColors.appBackground(isDark),
      body: Stack(
        children: [
          PullToRefreshWrapper(
            onRefresh: () =>
                ref.read(categoryWallpapersProvider(widget.category).notifier).refresh(),
            child: InfiniteScrollListener(
              onLoadMore: () => ref
                  .read(categoryWallpapersProvider(widget.category).notifier)
                  .loadMore(),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                SliverAppBar(
                  expandedHeight: 180,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      widget.category.name,
                      style: AppTextStyles.categoryCardTitle(),
                    ),
                    background: Container(
                      decoration: BoxDecoration(gradient: widget.category.gradient),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              widget.category.emoji,
                              style: const TextStyle(fontSize: 48),
                            ),
                            Text(
                              widget.category.name,
                              style: AppTextStyles.categoryTitle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: CategorySort.values.map((s) {
                        final active = sort == s;
                        final label = switch (s) {
                          CategorySort.latest => 'Latest',
                          CategorySort.popular => 'Popular',
                          CategorySort.random => 'Random',
                        };
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(label),
                            selected: active,
                            onSelected: (_) {
                              ref.read(categorySortProvider.notifier).state = s;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: async.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => ErrorState(
                      message: e is Failure ? e.message : 'Error',
                      onRetry: () => ref.invalidate(
                        categoryWallpapersProvider(widget.category),
                      ),
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
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
          ScrollToTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
