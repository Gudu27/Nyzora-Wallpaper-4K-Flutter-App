class UnsplashTopic {
  const UnsplashTopic({
    required this.id,
    required this.slug,
    required this.title,
    this.description,
  });

  factory UnsplashTopic.fromJson(Map<String, dynamic> json) {
    return UnsplashTopic(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  final String id;
  final String slug;
  final String title;
  final String? description;
}
