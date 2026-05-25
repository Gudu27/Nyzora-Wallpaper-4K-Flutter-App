import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';

final loadingOverlayProvider = StateProvider<bool>((ref) => false);

final loadingMessageProvider = StateProvider<String?>((ref) => null);

class LoadingOverlay extends ConsumerWidget {
  const LoadingOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(loadingOverlayProvider);
    final message = ref.watch(loadingMessageProvider);

    return Stack(
      children: [
        child,
        if (visible)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.accentPrimary,
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: AppTextStyles.bodyMedium(true),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

void showLoadingOverlay(WidgetRef ref, {String? message}) {
  ref.read(loadingMessageProvider.notifier).state = message;
  ref.read(loadingOverlayProvider.notifier).state = true;
}

void hideLoadingOverlay(WidgetRef ref) {
  ref.read(loadingOverlayProvider.notifier).state = false;
  ref.read(loadingMessageProvider.notifier).state = null;
}
