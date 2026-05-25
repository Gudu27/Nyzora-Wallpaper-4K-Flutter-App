import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/widgets/glass_card.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';

class PhotographerCredit extends ConsumerWidget {
  const PhotographerCredit({super.key, required this.wallpaper});

  final WallpaperEntity wallpaper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (wallpaper.source != 'unsplash' || wallpaper.photographerName == null) {
      return const SizedBox.shrink();
    }

    final isDark = ref.watch(isDarkModeProvider);
    final name = wallpaper.photographerName!;

    return GlassCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surfaceHighlight(isDark),
            child: const Icon(Icons.person, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Photo by $name', style: AppTextStyles.photographerName(isDark)),
                Text('on Unsplash', style: AppTextStyles.subtitle(isDark)),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              final url = wallpaper.photographerProfileUrl;
              if (url != null) {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
            },
            child: Text('View Profile →', style: AppTextStyles.seeAll(isDark)),
          ),
        ],
      ),
    );
  }
}
