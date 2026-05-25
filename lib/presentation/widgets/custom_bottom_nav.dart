import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';

class CustomBottomNav extends ConsumerWidget {
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Home', name: AppRoutes.home),
    (icon: Icons.search_rounded, label: 'Search', name: AppRoutes.search),
    (icon: Icons.grid_view_rounded, label: 'Categories', name: AppRoutes.categories),
    (icon: Icons.favorite_rounded, label: 'Favorites', name: AppRoutes.favorites),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 24,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigma,
            sigmaY: AppColors.glassBlurSigma,
          ),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.surfaceColorDark.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [AppColors.navBarShadow],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final active = currentIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onTap(index);
                      context.goNamed(tab.name);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: active ? AppColors.accentGradient1 : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tab.icon,
                            color: active
                                ? Colors.white
                                : AppColors.textTertiaryDark,
                            size: 24,
                          ),
                          if (active) ...[
                            const SizedBox(height: 2),
                            Text(
                              tab.label,
                              style: AppTextStyles.caption(
                                true,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
