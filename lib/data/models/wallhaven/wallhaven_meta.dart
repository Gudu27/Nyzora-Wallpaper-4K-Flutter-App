class WallhavenMeta {
  const WallhavenMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory WallhavenMeta.fromJson(Map<String, dynamic> json) {
    return WallhavenMeta(
      currentPage: _parseInt(json['current_page'], 1),
      lastPage: _parseInt(json['last_page'], 1),
      perPage: _parseInt(json['per_page'], 24),
      total: _parseInt(json['total'], 0),
    );
  }

  static int _parseInt(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  bool get hasMore => currentPage < lastPage;
}
