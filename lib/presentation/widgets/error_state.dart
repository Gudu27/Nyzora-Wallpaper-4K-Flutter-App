import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/widgets/glow_button.dart';

class ErrorState extends ConsumerWidget {
  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.accentError.withValues(alpha: 0.8)),
            const SizedBox(height: 16),
            Text(message, style: AppTextStyles.bodyMedium(isDark), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              GlowButton(label: 'Retry', onTap: onRetry!),
            ],
          ],
        ),
      ),
    );
  }
}
