import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/widgets/animated_gradient_bg.dart';
import 'package:wallie_4k_wallpapers/core/widgets/glow_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    (
      lottie: 'assets/lottie/gallery_animation.json',
      title: 'Millions of Wallpapers',
      desc:
          'Discover stunning HD & 4K wallpapers from the world\'s best photographers and artists',
    ),
    (
      lottie: 'assets/lottie/phone_wallpaper.json',
      title: 'One Tap to Apply',
      desc:
          'Set any wallpaper to your home screen, lock screen, or both — instantly with one tap',
    ),
    (
      lottie: 'assets/lottie/favorites_animation.json',
      title: 'Your Collection, Your Way',
      desc:
          'Save your favorites, search by category, and always find something new every day',
    ),
  ];

  Future<void> _finish() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.prefFirstLaunch, false);
    if (mounted) context.goNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.appBackgroundDark,
      body: GradientOrbsBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: isLast
                    ? const SizedBox(height: 48)
                    : TextButton(
                        onPressed: _finish,
                        child: Text(
                          'Skip',
                          style: AppTextStyles.caption(
                            true,
                            color: AppColors.textTertiaryDark,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (i) => setState(() => _page = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final p = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            p.lottie,
                            width: 200,
                            height: 200,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.wallpaper,
                              size: 120,
                              color: AppColors.accentPrimary.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            p.title,
                            style: AppTextStyles.displayBold(true),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            p.desc,
                            style: AppTextStyles.onboardingDesc(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.accentPrimary
                          : AppColors.textTertiaryDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: GlowButton(
                  label: isLast ? 'Get Started' : 'Next',
                  onTap: () {
                    if (isLast) {
                      _finish();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
