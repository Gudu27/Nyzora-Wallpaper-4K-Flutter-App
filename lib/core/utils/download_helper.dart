import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallie_4k_wallpapers/core/constants/app_constants.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';

abstract final class DownloadHelper {
  static final Dio _dio = Dio();

  static String qualityWidth(int qualityIndex) {
    switch (qualityIndex) {
      case 0:
        return '720';
      case 2:
        return '2160';
      default:
        return '1080';
    }
  }

  static String optimizeUnsplashUrl(String url, {required String width}) {
    if (!url.contains('unsplash')) return url;
    final uri = Uri.parse(url);
    final params = Map<String, String>.from(uri.queryParameters);
    params['w'] = width;
    params['q'] = width == '2160' ? '95' : '90';
    params['fm'] = 'webp';
    return uri.replace(queryParameters: params).toString();
  }

  static Future<String> downloadToTemp({
    required String url,
    required String fileName,
    CancelToken? cancelToken,
    void Function(int, int)? onProgress,
  }) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$fileName';
    await _dio.download(
      url,
      path,
      cancelToken: cancelToken,
      onReceiveProgress: onProgress,
    );
    return path;
  }

  static Future<bool> saveToGallery(String filePath) async {
    if (kIsWeb) return false;
    try {
      await Gal.putImage(
        filePath,
        album: AppConstants.downloadFolderName,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<String> downloadWallpaper({
    required WallpaperEntity wallpaper,
    required int qualityIndex,
    CancelToken? cancelToken,
    void Function(int, int)? onProgress,
  }) async {
    var url = wallpaper.fullUrl;
    if (wallpaper.source == 'unsplash') {
      url = optimizeUnsplashUrl(
        url,
        width: qualityWidth(qualityIndex),
      );
    }

    final ext = url.contains('.png') ? 'png' : 'jpg';
    final fileName =
        'nyzora_${wallpaper.id.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}.$ext';

    return downloadToTemp(
      url: url,
      fileName: fileName,
      cancelToken: cancelToken,
      onProgress: onProgress,
    );
  }

  static Future<void> deleteTempFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
