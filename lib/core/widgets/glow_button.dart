import 'package:flutter/material.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';

class GlowButton extends StatefulWidget {
  const GlowButton({
    super.key,
    required this.onTap,
    required this.label,
    this.icon,
    this.gradient = AppColors.accentGradient1,
    this.glowColor = AppColors.accentPrimary,
    this.height = 56,
    this.borderRadius = 16,
    this.enabled = true,
  });

  final VoidCallback onTap;
  final String label;
  final IconData? icon;
  final LinearGradient gradient;
  final Color glowColor;
  final double height;
  final double borderRadius;
  final bool enabled;

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final scale = _pressed && !reduceMotion ? 0.97 : 1.0;

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap();
            }
          : null,
      onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: scale,
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 100),
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: AppColors.textOnGradient, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(widget.label, style: AppTextStyles.buttonPrimary()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
