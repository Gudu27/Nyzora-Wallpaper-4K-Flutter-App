import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_colors.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/color_provider.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/detail/widgets/detail_bottom_sheet.dart';
import 'package:wallie_4k_wallpapers/presentation/screens/detail/widgets/detail_top_bar.dart';

class WallpaperDetailScreen extends ConsumerStatefulWidget {
  const WallpaperDetailScreen({super.key, required this.wallpaper});

  final WallpaperEntity wallpaper;

  @override
  ConsumerState<WallpaperDetailScreen> createState() =>
      _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends ConsumerState<WallpaperDetailScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    final wallpaper = widget.wallpaper;
    final colorAsync = ref.watch(extractedColorProvider(wallpaper));
    final overlaysVisible = ref.watch(detailOverlaysVisibleProvider);
    final dominantColor =
        colorAsync.valueOrNull ?? AppColors.accentPrimary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          ref.read(detailOverlaysVisibleProvider.notifier).state =
              !overlaysVisible;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    dominantColor.withValues(alpha: 0.3),
                    AppColors.appBackgroundDark,
                  ],
                ),
              ),
            ),
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Center(
                child: Hero(
                  tag: wallpaper.heroTag,
                  child: CachedNetworkImage(
                    imageUrl: wallpaper.fullUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accentPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: DetailTopBar(
                wallpaper: wallpaper,
                visible: overlaysVisible,
                onBack: () => context.pop(),
              ),
            ),
            DetailBottomSheet(wallpaper: wallpaper),
          ],
        ),
      ),
    );
  }
}
