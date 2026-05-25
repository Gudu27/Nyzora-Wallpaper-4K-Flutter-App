import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/domain/entities/category_entity.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/wallpaper_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/categories/categories_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/categories/category_detail_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/detail/wallpaper_detail_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/favorites/favorites_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/home/home_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/home/trending_all_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/main_shell/main_shell.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/no_internet/no_internet_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/search/search_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/settings/settings_screen.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/splash/splash_screen.dart';
import 'package:wallie_4k_wallpapers/core/widgets/webview_screen.dart';

CustomTransitionPage<T> _fadeScalePage<T>({
  required Widget child,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (reduceMotion) return child;
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          ),
          child: child,
        ),
      );
    },
  );
}

/// Deep link: /detail/unsplash_abc or /detail/wallhaven_123?source=wallhaven
WallpaperEntity? _wallpaperFromState(GoRouterState state) {
  if (state.extra is WallpaperEntity) {
    return state.extra as WallpaperEntity;
  }
  return null;
}

(String source, String rawId)? _parseDetailId(String encodedId) {
  if (encodedId.startsWith('unsplash_')) {
    return ('unsplash', encodedId);
  }
  if (encodedId.startsWith('wallhaven_')) {
    return ('wallhaven', encodedId);
  }
  if (encodedId.startsWith('peapix_')) {
    return ('peapix', encodedId);
  }
  final source = encodedId.contains('_') ? encodedId.split('_').first : 'unsplash';
  return (source, encodedId);
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splashPath,
    redirect: (context, state) {
      final uri = state.uri;
      if (uri.scheme == AppConstants.deepLinkScheme &&
          uri.host == AppConstants.deepLinkHost) {
        if (uri.pathSegments.length >= 2 && uri.pathSegments.first == 'detail') {
          return AppRoutes.detailPath(uri.pathSegments[1]);
        }
        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'home') {
          return AppRoutes.homePath;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutes.splash,
        path: AppRoutes.splashPath,
        pageBuilder: (context, state) =>
            _fadeScalePage(child: const SplashScreen()),
      ),
      GoRoute(
        name: AppRoutes.onboarding,
        path: AppRoutes.onboardingPath,
        pageBuilder: (context, state) =>
            _fadeScalePage(child: const OnboardingScreen()),
      ),
      GoRoute(
        name: AppRoutes.noInternet,
        path: AppRoutes.noInternetPath,
        pageBuilder: (context, state) =>
            _fadeScalePage(child: const NoInternetScreen()),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            name: AppRoutes.home,
            path: AppRoutes.homePath,
            pageBuilder: (context, state) => _fadeScalePage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            name: AppRoutes.search,
            path: AppRoutes.searchPath,
            pageBuilder: (context, state) => _fadeScalePage(
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),
          GoRoute(
            name: AppRoutes.categories,
            path: AppRoutes.categoriesPath,
            pageBuilder: (context, state) => _fadeScalePage(
              key: state.pageKey,
              child: const CategoriesScreen(),
            ),
          ),
          GoRoute(
            name: AppRoutes.favorites,
            path: AppRoutes.favoritesPath,
            pageBuilder: (context, state) => _fadeScalePage(
              key: state.pageKey,
              child: const FavoritesScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        name: AppRoutes.trendingAll,
        path: AppRoutes.trendingAllPath,
        pageBuilder: (context, state) =>
            _fadeScalePage(child: const TrendingAllScreen()),
      ),
      GoRoute(
        name: AppRoutes.categoryDetail,
        path: '/category/:id',
        pageBuilder: (context, state) {
          final category = state.extra as CategoryEntity? ??
              CategoryEntity.all.firstWhere(
                (c) => c.id == state.pathParameters['id'],
                orElse: () => CategoryEntity.all.first,
              );
          return _fadeScalePage(
            child: CategoryDetailScreen(category: category),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.wallpaperDetail,
        path: '/detail/:id',
        pageBuilder: (context, state) {
          final existing = _wallpaperFromState(state);
          if (existing != null) {
            return _fadeScalePage(
              key: ValueKey(existing.id),
              child: WallpaperDetailScreen(wallpaper: existing),
            );
          }
          final id = state.pathParameters['id'] ?? '';
          final parsed = _parseDetailId(id);
          if (parsed == null) {
            return _fadeScalePage(child: const _DetailLoadError());
          }
          return _fadeScalePage(
            child: _DetailLoader(
              id: parsed.$2,
              source: state.uri.queryParameters['source'] ?? parsed.$1,
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.settings,
        path: AppRoutes.settingsPath,
        pageBuilder: (context, state) =>
            _fadeScalePage(child: const SettingsScreen()),
      ),
      GoRoute(
        name: AppRoutes.webview,
        path: AppRoutes.webviewPath,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return _fadeScalePage(
            child: WebViewScreen(
              title: extra['title'] ?? state.uri.queryParameters['title'] ?? '',
              url: extra['url'] ?? state.uri.queryParameters['url'] ?? '',
            ),
          );
        },
      ),
    ],
  );
});

class _DetailLoader extends ConsumerWidget {
  const _DetailLoader({required this.id, required this.source});

  final String id;
  final String source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(getWallpaperDetailUsecaseProvider).call(
            id: id,
            source: source,
          ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
            ),
          );
        }
        return snapshot.data!.fold(
          (_) => const _DetailLoadError(),
          (wallpaper) => WallpaperDetailScreen(wallpaper: wallpaper),
        );
      },
    );
  }
}

class _DetailLoadError extends StatelessWidget {
  const _DetailLoadError();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: const Center(
        child: Text(
          'Could not load wallpaper',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
