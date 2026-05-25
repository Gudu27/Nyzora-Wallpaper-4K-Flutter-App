import 'package:wallie_4k_wallpapers/domain/entities/wallpaper_entity.dart';

class PeapixImage {
  const PeapixImage({
    required this.id,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.feedType,
    this.width,
    this.height,
  });

  factory PeapixImage.fromJson(Map<String, dynamic> json, String feedType) {
    final fullUrl = _string(json['fullUrl'] ?? json['fullurl']);
    final thumbUrl = _string(json['thumbUrl'] ?? json['thumbnailUrl']);
    final imageUrl = _string(json['imageUrl'] ?? json['image']);

    var url = fullUrl ?? imageUrl ?? thumbUrl ?? '';
    var thumb = thumbUrl ?? imageUrl ?? fullUrl ?? '';

    if (url.isEmpty) {
      final images = json['images'] as List<dynamic>?;
      final image = images?.isNotEmpty == true
          ? images!.first as Map<String, dynamic>
          : json;
      url = _string(image['url'] ?? image['image']) ?? '';
      thumb = thumb.isEmpty ? url : thumb;
    }

    final pageUrl = _string(json['pageUrl']) ?? '';
    final id = _idFromPageUrl(pageUrl) ??
        json['id']?.toString() ??
        (url.isNotEmpty ? url.hashCode.toString() : pageUrl.hashCode.toString());

    return PeapixImage(
      id: id,
      imageUrl: url,
      thumbnailUrl: thumb.isNotEmpty ? thumb : url,
      title: json['title'] as String? ??
          json['caption'] as String? ??
          'Daily Pick',
      feedType: feedType,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }

  static String? _string(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return value;
  }

  static String? _idFromPageUrl(String pageUrl) {
    if (pageUrl.isEmpty) return null;
    final segments = Uri.tryParse(pageUrl)?.pathSegments;
    if (segments == null || segments.isEmpty) return null;
    return segments.last;
  }

  static bool hasValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  final String id;
  final String imageUrl;
  final String thumbnailUrl;
  final String title;
  final String feedType;
  final int? width;
  final int? height;

  String get badgeLabel => feedType == 'bing' ? 'Bing Daily' : 'Spotlight';

  WallpaperEntity toEntity() {
    final full = hasValidUrl(imageUrl) ? imageUrl : thumbnailUrl;
    final thumb = hasValidUrl(thumbnailUrl) ? thumbnailUrl : full;
    return WallpaperEntity(
      id: 'peapix_${feedType}_$id',
      source: 'peapix',
      thumbnailUrl: thumb,
      fullUrl: full,
      title: title,
      width: width,
      height: height,
      tags: [feedType, 'daily'],
      createdAt: DateTime.now(),
    );
  }
}
