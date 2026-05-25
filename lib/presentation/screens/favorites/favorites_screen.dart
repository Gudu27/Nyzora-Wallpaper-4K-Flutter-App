import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/favorites_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/favorites/widgets/favorites_grid.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/empty_state.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/pull_to_refresh_wrapper.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final amoled = ref.watch(isAmoledProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.appBackground(isDark, amoled: amoled),
      appBar: AppBar(
        title: Row(
          children: [
            Text('FAVORITES', style: AppTextStyles.appBarTitle(isDark)),
            const SizedBox(width: 8),
            if (favorites.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${favorites.length}',
                  style: AppTextStyles.badge(isDark),
                ),
              ),
          ],
        ),
      ),
      body: favorites.isEmpty
          ? EmptyState(
              lottieAsset: 'assets/lottie/empty_heart.json',
              title: 'No favorites yet',
              subtitle: 'Tap ♡ on any wallpaper to save it here',
              actionLabel: 'Explore Wallpapers',
              onAction: () => context.goNamed(AppRoutes.home),
            )
          : PullToRefreshWrapper(
              onRefresh: () => ref.read(favoritesProvider.notifier).refresh(),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${favorites.length} saved wallpapers',
                      style: AppTextStyles.settingValue(isDark),
                    ),
                  ),
                  FavoritesGrid(wallpapers: favorites),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}
