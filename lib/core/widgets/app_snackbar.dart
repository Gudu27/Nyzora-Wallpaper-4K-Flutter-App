import 'package:flutter/material.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';

enum SnackType { success, error, info }

abstract final class AppSnackbar {
  static const EdgeInsets _margin =
      EdgeInsets.fromLTRB(16, 0, 16, 100);

  static void success(BuildContext context, String message) {
    _show(context, message, SnackType.success);
  }

  static void error(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    _show(context, message, SnackType.error, onAction: onRetry, actionLabel: 'Retry');
  }

  static void info(BuildContext context, String message) {
    _show(context, message, SnackType.info);
  }

  static void _show(
    BuildContext context,
    String message,
    SnackType type, {
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: _margin,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: _SnackContent(
          message: message,
          type: type,
          onAction: onAction,
          actionLabel: actionLabel,
        ),
      ),
    );
  }
}

class _SnackContent extends StatelessWidget {
  const _SnackContent({
    required this.message,
    required this.type,
    this.onAction,
    this.actionLabel,
  });

  final String message;
  final SnackType type;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final (bg, border, icon, iconColor) = switch (type) {
      SnackType.success => (
          AppColors.accentEmerald.withValues(alpha: 0.3),
          AppColors.accentEmerald,
          Icons.check_circle_rounded,
          AppColors.accentEmerald,
        ),
      SnackType.error => (
          AppColors.accentError.withValues(alpha: 0.3),
          AppColors.accentError,
          Icons.error_outline_rounded,
          AppColors.accentError,
        ),
      SnackType.info => (
          AppColors.surfaceHighlightDark,
          const Color(0xFF2A2A2A),
          Icons.info_outline_rounded,
          AppColors.textSecondaryDark,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium(true),
            ),
          ),
          if (onAction != null && actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: AppTextStyles.seeAll(true),
              ),
            ),
        ],
      ),
    );
  }
}
