import 'package:flutter/material.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';

class AnimatedGradientBg extends StatefulWidget {
  const AnimatedGradientBg({
    super.key,
    required this.child,
    this.gradient = AppColors.accentGradient2,
  });

  final Widget child;
  final LinearGradient gradient;

  @override
  State<AnimatedGradientBg> createState() => _AnimatedGradientBgState();
}

class _AnimatedGradientBgState extends State<AnimatedGradientBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -1 + (reduceMotion ? 0 : _controller.value * 0.4),
                -1,
              ),
              end: Alignment(
                1 - (reduceMotion ? 0 : _controller.value * 0.4),
                1,
              ),
              colors: widget.gradient.colors,
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class GradientOrbsBackground extends StatefulWidget {
  const GradientOrbsBackground({super.key, required this.child});

  final Widget child;

  @override
  State<GradientOrbsBackground> createState() => _GradientOrbsBackgroundState();
}

class _GradientOrbsBackgroundState extends State<GradientOrbsBackground>
    with TickerProviderStateMixin {
  late AnimationController _orb1;
  late AnimationController _orb2;

  @override
  void initState() {
    super.initState();
    _orb1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _orb2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orb1.dispose();
    _orb2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Stack(
      children: [
        Container(color: AppColors.appBackgroundDark),
        if (!reduceMotion) ...[
          AnimatedBuilder(
            animation: _orb1,
            builder: (context, _) {
              return Positioned(
                left: -80 + _orb1.value * 60,
                top: 80 + _orb1.value * 120,
                child: _orb(300, AppColors.accentPrimary.withValues(alpha: 0.15), 80),
              );
            },
          ),
          AnimatedBuilder(
            animation: _orb2,
            builder: (context, _) {
              return Positioned(
                right: -60 + _orb2.value * 40,
                bottom: 100 + _orb2.value * 80,
                child: _orb(250, AppColors.accentSecondary.withValues(alpha: 0.10), 60),
              );
            },
          ),
        ],
        widget.child,
      ],
    );
  }

  Widget _orb(double size, Color color, double blur) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color, blurRadius: blur, spreadRadius: blur / 2),
        ],
      ),
    );
  }
}
