import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';

class WallhavenWallpaper {
  const WallhavenWallpaper({
    required this.id,
    required this.url,
    required this.thumbUrl,
    required this.path,
    this.dimensionX,
    this.dimensionY,
    this.views,
    this.favorites,
    this.category,
    this.purity,
    this.createdAt,
    this.tags,
  });

  factory WallhavenWallpaper.fromJson(Map<String, dynamic> json) {
    return WallhavenWallpaper(
      id: json['id']?.toString() ?? '',
      url: json['url'] as String? ?? '',
      thumbUrl: json['thumbs']?['large'] as String? ??
          json['thumbs']?['small'] as String? ??
          json['path'] as String? ??
          '',
      path: json['path'] as String? ?? '',
      dimensionX: int.tryParse(json['dimension_x']?.toString() ?? ''),
      dimensionY: int.tryParse(json['dimension_y']?.toString() ?? ''),
      views: int.tryParse(json['views']?.toString() ?? ''),
      favorites: int.tryParse(json['favorites']?.toString() ?? ''),
      category: json['category'] as String?,
      purity: json['purity'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['tag_string'] as String?)
              ?.split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
    );
  }

  final String id;
  final String url;
  final String thumbUrl;
  final String path;
  final int? dimensionX;
  final int? dimensionY;
  final int? views;
  final int? favorites;
  final String? category;
  final String? purity;
  final DateTime? createdAt;
  final List<String>? tags;

  WallpaperEntity toEntity() {
    return WallpaperEntity(
      id: 'wallhaven_$id',
      source: 'wallhaven',
      thumbnailUrl: thumbUrl,
      fullUrl: path.isNotEmpty ? path : url,
      title: tags?.isNotEmpty == true ? tags!.first : category,
      width: dimensionX,
      height: dimensionY,
      tags: tags ?? [],
      views: views,
      downloads: favorites,
      createdAt: createdAt,
    );
  }
}
