import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/category_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/featured_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/trending_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/home/widgets/category_chips_row.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/home/widgets/daily_picks_section.dart';
import 'package:wallie_4k_wallpapers/core/utils/infinite_scroll_listener.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/home/widgets/hero_banner.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/home/widgets/latest_grid.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/home/widgets/trending_row.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/pull_to_refresh_wrapper.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/scroll_to_top_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  Future<void> _refresh() async {
    await Future.wait([
      ref.read(featuredProvider.notifier).refresh(),
      ref.read(trendingProvider.notifier).refresh(),
      ref.read(dailyPicksProvider.notifier).refresh(),
      ref.read(latestWallpapersProvider.notifier).refresh(),
    ]);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkModeProvider);
    final amoled = ref.watch(isAmoledProvider);

    return Scaffold(
      backgroundColor: AppColors.appBackground(isDark, amoled: amoled),
      body: Stack(
        children: [
          PullToRefreshWrapper(
            onRefresh: _refresh,
            child: InfiniteScrollListener(
              onLoadMore: () =>
                  ref.read(latestWallpapersProvider.notifier).loadMore(),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  expandedHeight: 70,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        color: AppColors.appBackground(isDark, amoled: amoled),
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.dividerColor(isDark),
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: SafeArea(
                        bottom: false,
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                gradient: AppColors.accentGradient1,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: const Icon(
                                Icons.wallpaper_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppConstants.appName,
                                style: AppTextStyles.appName(isDark),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _IconBtn(
                              icon: isDark
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                              tooltip: 'Toggle theme',
                              onTap: () => ref
                                  .read(themeProvider.notifier)
                                  .setDarkMode(!isDark),
                            ),
                            _IconBtn(
                              icon: Icons.notifications_outlined,
                              tooltip: 'Notifications',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No new notifications'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                            _IconBtn(
                              icon: Icons.settings_outlined,
                              tooltip: 'Settings',
                              onTap: () => context.pushNamed(AppRoutes.settings),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: HeroBanner()),
                const SliverToBoxAdapter(child: TrendingRow()),
                const SliverToBoxAdapter(child: CategoryChipsRow()),
                const SliverToBoxAdapter(child: DailyPicksSection()),
                const SliverToBoxAdapter(child: LatestGrid()),
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

class _IconBtn extends ConsumerWidget {
  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant(isDark),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
