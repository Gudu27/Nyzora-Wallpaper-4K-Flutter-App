class UnsplashUser {
  const UnsplashUser({
    required this.id,
    required this.username,
    required this.name,
    this.profileImage,
    this.links,
  });

  factory UnsplashUser.fromJson(Map<String, dynamic> json) {
    return UnsplashUser(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profileImage: json['profile_image'] as Map<String, dynamic>?,
      links: json['links'] as Map<String, dynamic>?,
    );
  }

  final String id;
  final String username;
  final String name;
  final Map<String, dynamic>? profileImage;
  final Map<String, dynamic>? links;

  String? get avatarUrl => profileImage?['small'] as String?;
  String? get profileHtml => links?['html'] as String?;
}
