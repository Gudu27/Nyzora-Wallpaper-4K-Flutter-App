import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/widgets/app_snackbar.dart';
import 'package:wallie_4k_wallpapers/core/widgets/glow_button.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/download_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/favorites_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/search_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/detail/widgets/photographer_credit.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/detail/widgets/set_wallpaper_dialog.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/detail/widgets/wallpaper_info_card.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/color_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/section_header.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailBottomSheet extends ConsumerWidget {
  const DetailBottomSheet({super.key, required this.wallpaper});

  final WallpaperEntity wallpaper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final downloadState = ref.watch(downloadStateProvider(wallpaper.id));
    final isFav = ref.watch(isFavoriteProvider(wallpaper));
    final related = ref.watch(relatedWallpapersProvider(wallpaper));

    return DraggableScrollableSheet(
      initialChildSize: 0.30,
      minChildSize: 0.18,
      maxChildSize: 0.68,
      snap: true,
      snapSizes: const [0.18, 0.30, 0.68],
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xE00A0A0A),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textDisabledDark,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ActionBtn(
                        icon: _downloadIcon(downloadState),
                        label: 'Download',
                        onTap: () => _download(context, ref),
                      ),
                      _ActionBtn(
                        icon: Icons.wallpaper_rounded,
                        label: 'Set as',
                        onTap: () =>
                            showSetWallpaperDialog(context, ref, wallpaper),
                      ),
                      _FavoriteBtn(
                        isFav: isFav,
                        onTap: () =>
                            ref.read(favoritesProvider.notifier).toggle(wallpaper),
                      ),
                      _ActionBtn(
                        icon: Icons.share_rounded,
                        label: 'Share',
                        onTap: () => Share.share(wallpaper.fullUrl),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GlowButton(
                    label: 'Download Wallpaper',
                    icon: Icons.download_rounded,
                    onTap: () => _download(context, ref),
                  ),
                  const SizedBox(height: 24),
                  WallpaperInfoCard(wallpaper: wallpaper),
                  const SizedBox(height: 16),
                  Text('TAGS', style: AppTextStyles.sectionLabel(isDark)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: wallpaper.tags.map((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(tag),
                            onPressed: () {
                              context.goNamed(AppRoutes.search);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PhotographerCredit(wallpaper: wallpaper),
                  const SizedBox(height: 16),
                  const SectionHeader(title: 'More Like This'),
                  related.when(
                    loading: () => const SizedBox(
                      height: 130,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (items) => SizedBox(
                      height: 130,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final wp = items[i];
                          return GestureDetector(
                            onTap: () => context.pushReplacementNamed(
                              AppRoutes.wallpaperDetail,
                              pathParameters: {'id': wp.id},
                              extra: wp,
                            ),
                            child: Container(
                              width: 90,
                              margin: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: wp.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  height: 130,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _downloadIcon(DownloadState state) {
    return switch (state) {
      DownloadState.loading => Icons.hourglass_top,
      DownloadState.success => Icons.check_circle,
      DownloadState.error => Icons.refresh,
      DownloadState.idle => Icons.download_rounded,
    };
  }

  Future<void> _download(BuildContext context, WidgetRef ref) async {
    final ok = await ref.read(downloadNotifierProvider).download(wallpaper);
    if (context.mounted) {
      if (ok) {
        AppSnackbar.success(context, 'Saved to gallery');
      } else {
        AppSnackbar.error(context, 'Download failed', onRetry: () => _download(context, ref));
      }
    }
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceHighlightDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Icon(icon, color: AppColors.textPrimaryDark, size: 22),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.actionLabel(true)),
        ],
      ),
    );
  }
}

class _FavoriteBtn extends StatefulWidget {
  const _FavoriteBtn({required this.isFav, required this.onTap});
  final bool isFav;
  final VoidCallback onTap;

  @override
  State<_FavoriteBtn> createState() => _FavoriteBtnState();
}

class _FavoriteBtnState extends State<_FavoriteBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void didUpdateWidget(_FavoriteBtn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFav != oldWidget.isFav) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _controller.forward(from: 0);
      },
      child: Column(
        children: [
          ScaleTransition(
            scale: _scale,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceHighlightDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Icon(
                widget.isFav ? Icons.favorite : Icons.favorite_border,
                color: widget.isFav
                    ? AppColors.accentRose
                    : AppColors.textSecondaryDark,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Favorites', style: AppTextStyles.actionLabel(true)),
        ],
      ),
    );
  }
}
