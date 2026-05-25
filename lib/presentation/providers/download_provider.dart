import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallie_4k_wallpapers/core/utils/download_helper.dart';
import 'package:wallie_4k_wallpapers/core/utils/permission_helper.dart';
import 'package:wallie_4k_wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallie_4k_wallpapers/presentation/providers/search_provider.dart';
import 'package:wallie_4k_wallpapers/core/theme/theme_provider.dart';

final downloadStateProvider =
    StateProvider.family<DownloadState, String>((ref, id) => DownloadState.idle);

class DownloadNotifier {
  DownloadNotifier(this._ref);
  final Ref _ref;
  CancelToken? _token;

  Future<bool> download(WallpaperEntity wallpaper) async {
    final id = wallpaper.id;
    _ref.read(downloadStateProvider(id).notifier).state = DownloadState.loading;

    try {
      final hasPermission = await PermissionHelper.requestStoragePermission();
      if (!hasPermission) {
        _ref.read(downloadStateProvider(id).notifier).state = DownloadState.error;
        return false;
      }

      var downloadUrl = wallpaper.fullUrl;

      if (wallpaper.source == 'unsplash') {
        final repo = _ref.read(wallpaperRepositoryProvider);
        final result = await repo.triggerUnsplashDownload(
          wallpaper.id.replaceFirst('unsplash_', ''),
        );
        final location = result.fold((_) => null, (url) => url);
        if (location != null && location.isNotEmpty) {
          downloadUrl = location;
        } else if (wallpaper.downloadLocationUrl != null) {
          downloadUrl = wallpaper.downloadLocationUrl!;
        }
      }

      final qualityIndex = _ref.read(themeProvider).downloadQualityIndex;
      _token = CancelToken();

      final path = await DownloadHelper.downloadWallpaper(
        wallpaper: wallpaper.copyWith(fullUrl: downloadUrl),
        qualityIndex: qualityIndex,
        cancelToken: _token,
      );

      final saved = await DownloadHelper.saveToGallery(path);
      await DownloadHelper.deleteTempFile(path);

      if (saved) {
        _ref.read(downloadStateProvider(id).notifier).state =
            DownloadState.success;
        Future.delayed(const Duration(seconds: 2), () {
          _ref.read(downloadStateProvider(id).notifier).state =
              DownloadState.idle;
        });
        return true;
      }

      _ref.read(downloadStateProvider(id).notifier).state = DownloadState.error;
      return false;
    } catch (_) {
      _ref.read(downloadStateProvider(id).notifier).state = DownloadState.error;
      return false;
    }
  }

  void cancel() => _token?.cancel();
}

final downloadNotifierProvider = Provider<DownloadNotifier>((ref) {
  return DownloadNotifier(ref);
});
