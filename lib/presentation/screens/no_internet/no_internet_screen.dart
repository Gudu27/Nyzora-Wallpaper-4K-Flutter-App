import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:lottie/lottie.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_text_styles.dart';
import 'package:wallie_4k_wallpapers/core/utils/connectivity_helper.dart';
import 'package:wallie_4k_wallpapers/core/widgets/app_snackbar.dart';
import 'package:wallie_4k_wallpapers/core/widgets/glow_button.dart';

class NoInternetScreen extends ConsumerWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(connectivityStatusProvider, (prev, next) {
      next.whenData((connected) {
        if (connected && context.mounted) {
          AppSnackbar.success(context, 'Connection restored');
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed(AppRoutes.home);
          }
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.appBackgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/no_internet.json',
                width: 180,
                height: 180,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.wifi_off_rounded,
                  size: 100,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Internet Connection',
                style: AppTextStyles.noInternetTitle(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Please check your connection and try again',
                style: AppTextStyles.subtitle(true),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              GlowButton(
                label: 'Try Again',
                onTap: () async {
                  final ok =
                      await ref.read(connectivityServiceProvider).checkConnectivity();
                  if (ok && context.mounted) {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.home);
                    }
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Your saved favorites are still available offline',
                style: AppTextStyles.caption(
                  true,
                  color: AppColors.textTertiaryDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
