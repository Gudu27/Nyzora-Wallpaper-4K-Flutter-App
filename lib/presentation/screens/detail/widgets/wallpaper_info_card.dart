import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/utils/app_utils.dart';
import 'package:wallie_4k_wallpapers/core/widgets/glass_card.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';

class WallpaperInfoCard extends ConsumerWidget {
  const WallpaperInfoCard({super.key, required this.wallpaper});

  final WallpaperEntity wallpaper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return GlassCard(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _StatItem(
            icon: '📐',
            label: 'Resolution',
            value: AppUtils.resolutionLabel(wallpaper.width, wallpaper.height),
            isDark: isDark,
          ),
          _StatItem(
            icon: '👁',
            label: 'Views',
            value: AppUtils.formatCount(wallpaper.views),
            isDark: isDark,
          ),
          _StatItem(
            icon: '⬇',
            label: 'Downloads',
            value: AppUtils.formatCount(wallpaper.downloads),
            isDark: isDark,
          ),
          _StatItem(
            icon: '📅',
            label: 'Added',
            value: AppUtils.formatDate(wallpaper.createdAt),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final String icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$icon $label', style: AppTextStyles.statLabel(isDark)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.statValue(isDark)),
      ],
    );
  }
}
