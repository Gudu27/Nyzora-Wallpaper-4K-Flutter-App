import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/router/app_routes.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/favorites_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/widgets/staggered_grid.dart';

class FavoritesGrid extends ConsumerWidget {
  const FavoritesGrid({super.key, required this.wallpapers});

  final List<WallpaperEntity> wallpapers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WallpaperStaggeredGrid(
      wallpapers: wallpapers,
      wrapDismissible: (wp, child) => FavoriteDismissibleCard(
        wallpaper: wp,
        child: child,
      ),
      onTap: (wp) => context.pushNamed(
        AppRoutes.wallpaperDetail,
        pathParameters: {'id': wp.id},
        extra: wp,
      ),
    );
  }
}

class FavoriteDismissibleCard extends ConsumerWidget {
  const FavoriteDismissibleCard({
    super.key,
    required this.wallpaper,
    required this.child,
  });

  final WallpaperEntity wallpaper;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('${wallpaper.source}_${wallpaper.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.withValues(alpha: 0.3),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) {
        ref.read(favoritesProvider.notifier).remove(wallpaper);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Wallpaper removed'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () =>
                  ref.read(favoritesProvider.notifier).toggle(wallpaper),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          ),
        );
      },
      child: child,
    );
  }
}
