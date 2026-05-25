import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/router/app_router.dart';
import 'package:wallie_4k_wallpapers/core/theme/app_theme.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';
import 'package:wallie_4k_wallpapers/core/widgets/loading_overlay.dart';

class WallieApp extends ConsumerWidget {
  const WallieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Wallie 4K Wallpapers',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(amoled: themeSettings.amoled),
      themeMode: themeSettings.isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        return LoadingOverlay(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
