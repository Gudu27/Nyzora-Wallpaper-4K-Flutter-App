import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/domain/entities/category_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/categories/widgets/category_card.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/section_header.dart';

class TrendingTags extends ConsumerWidget {
  const TrendingTags({super.key, required this.onTagTap});

  final ValueChanged<String> onTagTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Trending'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.trendingSearchTags.map((tag) {
              return GestureDetector(
                onTap: () => onTagTap(tag),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1.5,
                      color: AppColors.accentPrimary.withValues(alpha: 0.5),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentPrimary.withValues(alpha: 0.15),
                        AppColors.accentSecondary.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Text(tag, style: AppTextStyles.chip(isDark)),
                ),
              );
            }).toList(),
          ),
        ),
        const SectionHeader(title: 'Explore'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.6,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final cat = CategoryEntity.all[index];
              return CategoryCard(
                category: cat,
                compact: true,
                onTap: () => context.pushNamed(
                  AppRoutes.categoryDetail,
                  pathParameters: {'id': cat.id},
                  extra: cat,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
