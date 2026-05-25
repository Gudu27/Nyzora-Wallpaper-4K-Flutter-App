import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';

class PullToRefreshWrapper extends ConsumerWidget {
  const PullToRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.accentPrimary,
      backgroundColor: AppColors.surfaceColor(isDark),
      strokeWidth: 2.5,
      child: child,
    );
  }
}
