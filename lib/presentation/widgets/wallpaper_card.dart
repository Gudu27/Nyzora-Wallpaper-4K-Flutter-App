import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/utils/app_utils.dart';
import 'package:wallie_4k_wallpapers/core/widgets/app_snackbar.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/download_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/favorites_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/wallpaper_card_shimmer.dart';

class WallpaperCard extends ConsumerWidget {
  const WallpaperCard({
    super.key,
    required this.wallpaper,
    this.aspectRatio = 1.4,
    this.showSource = true,
    this.onTap,
  });

  final WallpaperEntity wallpaper;
  final double aspectRatio;
  final bool showSource;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final isFav = ref.watch(isFavoriteProvider(wallpaper));

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Hero(
        tag: wallpaper.heroTag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap ??
                () => context.pushNamed(
                      AppRoutes.wallpaperDetail,
                      pathParameters: {'id': wallpaper.id},
                      extra: wallpaper,
                    ),
            onLongPress: () => _showQuickActions(context, ref),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: wallpaper.thumbnailUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 400,
                    fadeInDuration: const Duration(milliseconds: 200),
                    placeholder: (_, __) =>
                        const WallpaperCardShimmer(),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.surfaceHighlight(isDark),
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 4,
                    bottom: 4,
                    child: IconButton(
                      tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                      onPressed: () =>
                          ref.read(favoritesProvider.notifier).toggle(wallpaper),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.accentRose : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  if (showSource)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: _SourceBadge(source: wallpaper.source),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceColorDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.download_rounded),
                title: const Text('Download'),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(downloadNotifierProvider).download(wallpaper).then((ok) {
                    if (context.mounted) {
                      if (ok) {
                        AppSnackbar.success(context, 'Saved to gallery');
                      } else {
                        AppSnackbar.error(context, 'Download failed');
                      }
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.wallpaper_rounded),
                title: const Text('Set Wallpaper'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.pushNamed(
                    AppRoutes.wallpaperDetail,
                    pathParameters: {'id': wallpaper.id},
                    extra: wallpaper,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Add to Favorites'),
                onTap: () {
                  ref.read(favoritesProvider.notifier).toggle(wallpaper);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_rounded),
                title: const Text('Share'),
                onTap: () {
                  Share.share(wallpaper.fullUrl);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.source});
  final String source;

  @override
  Widget build(BuildContext context) {
    final isUnsplash = source == 'unsplash';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isUnsplash ? AppColors.accentCyan : AppColors.accentPrimary)
            .withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        AppUtils.sourceShort(source),
        style: AppTextStyles.badge(true),
      ),
    );
  }
}
