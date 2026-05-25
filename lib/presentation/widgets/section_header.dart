import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';

class SectionHeader extends ConsumerWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onSeeAll,
  });

  final String title;
  final String? trailing;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.sectionLabel(isDark),
          ),
          const Spacer(),
          if (trailing != null)
            Text(trailing!, style: AppTextStyles.caption(isDark))
          else if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Text('See All →', style: AppTextStyles.seeAll(isDark)),
            ),
        ],
      ),
    );
  }
}
