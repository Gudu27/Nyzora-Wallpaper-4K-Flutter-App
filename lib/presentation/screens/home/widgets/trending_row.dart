import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/errors/failure.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/trending_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/error_state.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/section_header.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/wallpaper_card_shimmer.dart';

class TrendingRow extends ConsumerWidget {
  const TrendingRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(trendingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Trending Now',
          onSeeAll: () => context.pushNamed(AppRoutes.trendingAll),
        ),
        async.when(
          loading: () => SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              itemCount: 5,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 8),
                child: ShimmerCard(width: 130, height: 200, borderRadius: 16),
              ),
            ),
          ),
          error: (e, _) => ErrorState(
            message: e is Failure ? e.message : 'Failed to load trending',
            onRetry: () => ref.invalidate(trendingProvider),
          ),
          data: (items) => SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final wp = items[index];
                final rank = index + 1;
                return GestureDetector(
                  onTap: () => context.pushNamed(
                    AppRoutes.wallpaperDetail,
                    pathParameters: {'id': wp.id},
                    extra: wp,
                  ),
                  child: Hero(
                    tag: wp.heroTag,
                    child: Container(
                      width: 130,
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
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
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: rank <= 3
                                      ? AppColors.accentGradient1
                                      : null,
                                  color: rank > 3
                                      ? AppColors.surfaceVariantDark
                                      : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '#$rank',
                                  style: AppTextStyles.rankBadge(),
                                ),
                              ),
                            ),
                            if (wp.photographerName != null)
                              Positioned(
                                left: 8,
                                right: 8,
                                bottom: 8,
                                child: Text(
                                  wp.photographerName!,
                                  style: AppTextStyles.badge(true).copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
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
