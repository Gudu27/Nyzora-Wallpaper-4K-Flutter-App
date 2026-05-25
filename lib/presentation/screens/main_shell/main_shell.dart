import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/utils/connectivity_helper.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/custom_bottom_nav.dart';

final shellTabIndexProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  int _indexFromLocation(String location) {
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/categories')) return 2;
    if (location.startsWith('/favorites')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final amoled = ref.watch(isAmoledProvider);
    final location = GoRouterState.of(context).uri.toString();
    final tabIndex = _indexFromLocation(location);

    ref.listen(connectivityStatusProvider, (prev, next) {
      next.whenData((connected) {
        if (!connected && context.mounted) {
          context.pushNamed(AppRoutes.noInternet);
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.appBackground(isDark, amoled: amoled),
      body: Stack(
        children: [
          child,
          CustomBottomNav(
            currentIndex: tabIndex,
            onTap: (i) => ref.read(shellTabIndexProvider.notifier).state = i,
          ),
        ],
      ),
    );
  }
}
