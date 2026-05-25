import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/featured_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/wallpaper_card_shimmer.dart';

class FeaturedCarousel extends ConsumerStatefulWidget {
  const FeaturedCarousel({super.key});

  @override
  ConsumerState<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends ConsumerState<FeaturedCarousel> {
  final _pageController = PageController();
  Timer? _timer;
  int _current = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll(int count) {
    _timer?.cancel();
    if (count <= 1) return;
    _timer = Timer.periodic(
      const Duration(seconds: AppConstants.carouselAutoScrollSeconds),
      (_) {
        if (!_pageController.hasClients) return;
        final next = (_current + 1) % count;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  String _badge(WallpaperEntity wp) {
    if (wp.tags.contains('bing')) return 'Bing Daily';
    if (wp.tags.contains('spotlight')) return 'Spotlight';
    return 'Featured';
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(featuredProvider);

    return async.when(
      loading: () => const SizedBox(
        height: 260,
        child: ShimmerCard(width: double.infinity, height: 260, borderRadius: 0),
      ),
      error: (_, __) => const SizedBox(height: 0),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startAutoScroll(items.length);
        });

        return Column(
          children: [
            SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _current = i),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final wp = items[index];
                  return GestureDetector(
                    onTap: () => context.pushNamed(
                      AppRoutes.wallpaperDetail,
                      pathParameters: {'id': wp.id},
                      extra: wp,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: wp.fullUrl.isNotEmpty
                              ? wp.fullUrl
                              : wp.thumbnailUrl,
                          fit: BoxFit.cover,
                          memCacheWidth: 800,
                          errorWidget: (_, __, ___) => const ColoredBox(
                            color: Color(0xFF1A1A2E),
                            child: Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: Colors.white54,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 120,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.9),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: _GlassBadge(label: _badge(wp)),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  wp.title ?? 'Featured',
                                  style: AppTextStyles.bannerTitle(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentEmerald,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "TODAY'S PICK",
                                  style: AppTextStyles.badge(true),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(items.length, (i) {
                final active = i == _current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.accentPrimary
                        : AppColors.textTertiaryDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: AppColors.glassBackground,
        child: Text(label, style: AppTextStyles.badge(true)),
      ),
    );
  }
}
