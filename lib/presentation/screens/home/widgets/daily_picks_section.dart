import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/utils/color_extractor.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/featured_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/section_header.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/wallpaper_card_shimmer.dart';

class DailyPicksSection extends ConsumerWidget {
  const DailyPicksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dailyPicksProvider);
    final dateStr = DateFormat('MMM d').format(DateTime.now());

    return Column(
      children: [
        SectionHeader(title: 'Daily Picks', trailing: dateStr),
        async.when(
          loading: () => SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 8),
                child: ShimmerCard(width: 155, height: 240, borderRadius: 20),
              ),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (items) => SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final wp = items[index];
                final borderColor = ref
                        .read(colorExtractorProvider)
                        .hexToColor(wp.dominantColorHex)
                        .withValues(alpha: 0.6);
                final badge = wp.tags.contains('bing') ? 'Bing' : 'Spotlight';

                return GestureDetector(
                  onTap: () => context.pushNamed(
                    AppRoutes.wallpaperDetail,
                    pathParameters: {'id': wp.id},
                    extra: wp,
                  ),
                  child: Container(
                    width: 155,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: wp.thumbnailUrl,
                            fit: BoxFit.cover,
                            memCacheWidth: 400,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 90,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.75),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.glassBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(badge, style: AppTextStyles.badge(true)),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            right: 8,
                            bottom: 8,
                            child: Text(
                              wp.title ?? 'Daily Pick',
                              style: AppTextStyles.bodySemiBold(
                                true,
                                color: Colors.white,
                              ).copyWith(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
