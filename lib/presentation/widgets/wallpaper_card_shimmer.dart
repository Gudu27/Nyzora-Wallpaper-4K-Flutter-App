import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShimmerCard extends ConsumerWidget {
  const ShimmerCard({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase(isDark),
      highlightColor: AppColors.shimmerHighlight(isDark),
      direction: ShimmerDirection.ltr,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase(isDark),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class WallpaperCardShimmer extends ConsumerWidget {
  const WallpaperCardShimmer({super.key, this.height = 200});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ShimmerCard(width: double.infinity, height: 200, borderRadius: 16);
  }
}
