import 'package:wallie_4k_wallpapers/core/constants/api_constants.dart';
import 'package:wallie_4k_wallpapers/data/models/unsplash/unsplash_user.dart';
import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';

class UnsplashPhoto {
  const UnsplashPhoto({
    required this.id,
    required this.urls,
    this.description,
    this.altDescription,
    this.user,
    this.width,
    this.height,
    this.color,
    this.tags,
    this.views,
    this.downloads,
    this.createdAt,
    this.links,
  });

  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    return UnsplashPhoto(
      id: json['id'] as String,
      urls: json['urls'] as Map<String, dynamic>,
      description: json['description'] as String?,
      altDescription: json['alt_description'] as String?,
      user: json['user'] != null
          ? UnsplashUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      width: json['width'] as int?,
      height: json['height'] as int?,
      color: json['color'] as String?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => (e as Map)['title'] as String? ?? '')
          .where((t) => t.isNotEmpty)
          .toList(),
      views: json['views'] as int?,
      downloads: json['downloads'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      links: json['links'] as Map<String, dynamic>?,
    );
  }

  final String id;
  final Map<String, dynamic> urls;
  final String? description;
  final String? altDescription;
  final UnsplashUser? user;
  final int? width;
  final int? height;
  final String? color;
  final List<String>? tags;
  final int? views;
  final int? downloads;
  final DateTime? createdAt;
  final Map<String, dynamic>? links;

  String get rawUrl => urls['raw'] as String? ?? urls['regular'] as String? ?? '';

  static String thumbnailUrl(String raw) {
    final uri = Uri.parse(raw);
    final params = Map<String, String>.from(uri.queryParameters);
    params['w'] = '400';
    params['q'] = '75';
    params['fm'] = 'webp';
    params['fit'] = 'crop';
    return uri.replace(queryParameters: params).toString();
  }

  static String fullUrl(String raw) {
    final uri = Uri.parse(raw);
    final params = Map<String, String>.from(uri.queryParameters);
    params['w'] = '1080';
    params['q'] = '90';
    params['fm'] = 'webp';
    return uri.replace(queryParameters: params).toString();
  }

  WallpaperEntity toEntity() {
    final raw = rawUrl;
    final username = user?.username ?? '';
    return WallpaperEntity(
      id: 'unsplash_$id',
      source: 'unsplash',
      thumbnailUrl: thumbnailUrl(raw),
      fullUrl: fullUrl(raw),
      title: description ?? altDescription,
      photographerName: user?.name,
      photographerUsername: username,
      photographerProfileUrl: username.isNotEmpty
          ? 'https://unsplash.com/@$username?utm_source=${ApiConstants.appUtmSource}&utm_medium=referral'
          : null,
      width: width,
      height: height,
      dominantColorHex: color,
      tags: tags ?? [],
      views: views,
      downloads: downloads,
      createdAt: createdAt,
      downloadLocationUrl: links?['download_location'] as String?,
    );
  }
}
