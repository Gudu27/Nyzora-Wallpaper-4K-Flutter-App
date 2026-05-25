import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/utils/app_utils.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/color_provider.dart';

class DetailTopBar extends ConsumerWidget {
  const DetailTopBar({
    super.key,
    required this.wallpaper,
    required this.visible,
    required this.onBack,
  });

  final WallpaperEntity wallpaper;
  final bool visible;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: Colors.black.withValues(alpha: 0.4),
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 8,
              left: 8,
              right: 8,
              bottom: 8,
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back',
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryDark),
                ),
                const Spacer(),
                Text(
                  AppUtils.resolutionLabel(wallpaper.width, wallpaper.height),
                  style: AppTextStyles.caption(true),
                ),
                const SizedBox(width: 8),
                _SourcePill(source: wallpaper.source),
                IconButton(
                  tooltip: 'More options',
                  onPressed: () => _showMenu(context),
                  icon: const Icon(Icons.more_vert, color: AppColors.textPrimaryDark),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceColorDark,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text('Share'),
              onTap: () {
                Share.share(wallpaper.fullUrl);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Report'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourcePill extends StatelessWidget {
  const _SourcePill({required this.source});
  final String source;

  @override
  Widget build(BuildContext context) {
    final isUnsplash = source == 'unsplash';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isUnsplash ? AppColors.accentCyan : AppColors.accentPrimary)
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        AppUtils.sourceLabel(source),
        style: AppTextStyles.badge(true),
      ),
    );
  }
}
