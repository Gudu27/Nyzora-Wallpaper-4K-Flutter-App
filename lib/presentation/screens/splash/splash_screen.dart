import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/utils/connectivity_helper.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([
      ref.read(connectivityServiceProvider).checkConnectivity(),
      Future<void>.delayed(const Duration(milliseconds: 2200)),
    ]);

    if (!mounted) return;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    final prefs = ref.read(sharedPreferencesProvider);
    final firstLaunch = prefs.getBool(AppConstants.prefFirstLaunch) ?? true;
    final connected = ref.read(connectivityServiceProvider).lastConnected;

    if (!connected) {
      context.goNamed(AppRoutes.noInternet);
      return;
    }
    if (firstLaunch) {
      context.goNamed(AppRoutes.onboarding);
    } else {
      context.goNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: AppColors.appBackgroundDark,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: AppColors.accentGradient1,
                boxShadow: [AppColors.cardGlow],
              ),
              child: const Icon(
                Icons.wallpaper_rounded,
                size: 40,
                color: Colors.white,
              ),
            )
                .animate(autoPlay: !reduceMotion)
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 24),
            Text(AppConstants.appName, style: AppTextStyles.splashTitle())
                .animate(autoPlay: !reduceMotion, delay: 400.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(AppConstants.appTagline, style: AppTextStyles.tagline())
                .animate(autoPlay: !reduceMotion, delay: 700.ms)
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 48),
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: AppColors.surfaceVariantDark,
                  valueColor: const AlwaysStoppedAnimation(AppColors.accentPrimary),
                ),
              ),
            )
                .animate(autoPlay: !reduceMotion, delay: 900.ms)
                .fadeIn(duration: 1200.ms),
          ],
        ),
      ),
    );
  }
}
