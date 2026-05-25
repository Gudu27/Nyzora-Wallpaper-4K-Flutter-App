import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/search_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/section_header.dart';

class RecentSearches extends ConsumerWidget {
  const RecentSearches({
    super.key,
    required this.onTap,
  });

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final recent = ref.watch(recentSearchesProvider);

    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Text(
                'RECENT SEARCHES',
                style: AppTextStyles.sectionLabel(isDark),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    ref.read(recentSearchesProvider.notifier).clearAll(),
                child: Text('Clear All', style: AppTextStyles.seeAll(isDark)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recent.map((term) {
              return GestureDetector(
                onTap: () => onTap(term),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.glassBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            size: 14,
                            color: AppColors.textSecondary(isDark),
                          ),
                          const SizedBox(width: 6),
                          Text(term, style: AppTextStyles.chip(isDark)),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => ref
                                .read(recentSearchesProvider.notifier)
                                .removeSearch(term),
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: AppColors.textTertiary(isDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
