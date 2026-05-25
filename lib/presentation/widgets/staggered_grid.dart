import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/wallpaper_card.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/wallpaper_card_shimmer.dart';

class WallpaperStaggeredGrid extends ConsumerWidget {
  const WallpaperStaggeredGrid({
    super.key,
    required this.wallpapers,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.onTap,
    this.wrapDismissible,
    this.animateEntrance = true,
  });

  final List<WallpaperEntity> wallpapers;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final void Function(WallpaperEntity)? onTap;
  final Widget Function(WallpaperEntity wallpaper, Widget child)? wrapDismissible;
  final bool animateEntrance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return AnimationLimiter(
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: wallpapers.length + (isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= wallpapers.length) {
            return const WallpaperCardShimmer();
          }
          final wp = wallpapers[index];
          final aspect = (wp.height != null && wp.width != null && wp.width! > 0)
              ? wp.height! / wp.width!
              : 1.4;

          Widget card = WallpaperCard(
            wallpaper: wp,
            aspectRatio: aspect.clamp(1.0, 2.0),
            onTap: () => onTap?.call(wp),
          );

          if (wrapDismissible != null) {
            card = wrapDismissible!(wp, card);
          }

          if (!animateEntrance || reduceMotion) return card;

          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 50),
            columnCount: 2,
            child: SlideAnimation(
              verticalOffset: 40,
              child: FadeInAnimation(child: card),
            ),
          );
        },
      ),
    );
  }
}
