import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/domain/entities/category_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/category_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/section_header.dart';

class CategoryChipsRow extends ConsumerWidget {
  const CategoryChipsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final selected = ref.watch(selectedHomeCategoryProvider);
    final categories = CategoryEntity.all.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Categories',
          onSeeAll: () => context.goNamed(AppRoutes.categories),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final active = selected == cat.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    ref.read(selectedHomeCategoryProvider.notifier).state =
                        active ? null : cat.id;
                    ref.invalidate(latestWallpapersProvider);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: active
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: const BoxDecoration(
                              gradient: AppColors.accentGradient1,
                            ),
                            child: Text(
                              '${cat.emoji} ${cat.name}',
                              style: AppTextStyles.chip(isDark, active: true),
                            ),
                          )
                        : BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.glassBackground,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.glassBorder),
                              ),
                              child: Text(
                                '${cat.emoji} ${cat.name}',
                                style: AppTextStyles.chip(isDark),
                              ),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
