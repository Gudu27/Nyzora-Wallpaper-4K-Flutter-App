import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/utils/wallpaper_setter.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/utils/download_helper.dart';
import 'package:wallie_4k_wallpapers/core/widgets/app_snackbar.dart';
import 'package:wallie_4k_wallpapers/core/widgets/loading_overlay.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';

Future<void> showSetWallpaperDialog(
  BuildContext context,
  WidgetRef ref,
  WallpaperEntity wallpaper,
) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: AppColors.surfaceColorDark.withValues(alpha: 0.9),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set as Wallpaper', style: AppTextStyles.detailTitle(true)),
                const SizedBox(height: 8),
                Text(
                  'Choose where to set this wallpaper',
                  style: AppTextStyles.subtitle(true),
                ),
                const SizedBox(height: 16),
                _Option(
                  icon: Icons.smartphone_rounded,
                  label: 'Home Screen',
                  onTap: () =>
                      _apply(ctx, ref, wallpaper, WallpaperLocation.home),
                ),
                const Divider(color: AppColors.dividerColorDark),
                _Option(
                  icon: Icons.lock_outline,
                  label: 'Lock Screen',
                  onTap: () =>
                      _apply(ctx, ref, wallpaper, WallpaperLocation.lock),
                ),
                const Divider(color: AppColors.dividerColorDark),
                _Option(
                  icon: Icons.auto_awesome,
                  label: 'Both Screens',
                  onTap: () =>
                      _apply(ctx, ref, wallpaper, WallpaperLocation.both),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minTileHeight: 56,
      leading: Icon(icon, color: AppColors.accentPrimary),
      title: Text(label, style: AppTextStyles.settingLabel(true)),
      onTap: onTap,
    );
  }
}

Future<void> _apply(
  BuildContext ctx,
  WidgetRef ref,
  WallpaperEntity wallpaper,
  WallpaperLocation location,
) async {
  Navigator.pop(ctx);
  showLoadingOverlay(ref, message: 'Setting wallpaper...');
  try {
    final qualityIndex = ref.read(themeProvider).downloadQualityIndex;
    final path = await DownloadHelper.downloadWallpaper(
      wallpaper: wallpaper,
      qualityIndex: qualityIndex,
    );
    final ok = await WallpaperSetter.setFromFile(path, location);
    await DownloadHelper.deleteTempFile(path);
    hideLoadingOverlay(ref);
    if (ctx.mounted) {
      if (ok) {
        AppSnackbar.success(ctx, 'Wallpaper applied successfully');
      } else {
        AppSnackbar.error(ctx, 'Failed to set wallpaper');
      }
    }
  } catch (_) {
    hideLoadingOverlay(ref);
    if (ctx.mounted) {
      AppSnackbar.error(ctx, 'Failed to set wallpaper');
    }
  }
}
