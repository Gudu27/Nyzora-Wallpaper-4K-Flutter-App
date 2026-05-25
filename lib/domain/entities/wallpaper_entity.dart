import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class WallpaperEntity extends HiveObject {
  WallpaperEntity({
    required this.id,
    required this.source,
    required this.thumbnailUrl,
    required this.fullUrl,
    this.title,
    this.photographerName,
    this.photographerUsername,
    this.photographerProfileUrl,
    this.width,
    this.height,
    this.dominantColorHex,
    this.tags = const [],
    this.views,
    this.downloads,
    this.createdAt,
    this.downloadLocationUrl,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String source;

  @HiveField(2)
  final String thumbnailUrl;

  @HiveField(3)
  final String fullUrl;

  @HiveField(4)
  final String? title;

  @HiveField(5)
  final String? photographerName;

  @HiveField(6)
  final String? photographerUsername;

  @HiveField(7)
  final String? photographerProfileUrl;

  @HiveField(8)
  final int? width;

  @HiveField(9)
  final int? height;

  @HiveField(10)
  final String? dominantColorHex;

  @HiveField(11)
  final List<String> tags;

  @HiveField(12)
  final int? views;

  @HiveField(13)
  final int? downloads;

  @HiveField(14)
  final DateTime? createdAt;

  @HiveField(15)
  final String? downloadLocationUrl;

  String get heroTag => 'wallpaper_$id';

  WallpaperEntity copyWith({
    String? id,
    String? source,
    String? thumbnailUrl,
    String? fullUrl,
    String? title,
    String? photographerName,
    String? photographerUsername,
    String? photographerProfileUrl,
    int? width,
    int? height,
    String? dominantColorHex,
    List<String>? tags,
    int? views,
    int? downloads,
    DateTime? createdAt,
    String? downloadLocationUrl,
  }) {
    return WallpaperEntity(
      id: id ?? this.id,
      source: source ?? this.source,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fullUrl: fullUrl ?? this.fullUrl,
      title: title ?? this.title,
      photographerName: photographerName ?? this.photographerName,
      photographerUsername: photographerUsername ?? this.photographerUsername,
      photographerProfileUrl:
          photographerProfileUrl ?? this.photographerProfileUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      dominantColorHex: dominantColorHex ?? this.dominantColorHex,
      tags: tags ?? this.tags,
      views: views ?? this.views,
      downloads: downloads ?? this.downloads,
      createdAt: createdAt ?? this.createdAt,
      downloadLocationUrl: downloadLocationUrl ?? this.downloadLocationUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallpaperEntity && other.id == id && other.source == source;

  @override
  int get hashCode => Object.hash(id, source);
}
