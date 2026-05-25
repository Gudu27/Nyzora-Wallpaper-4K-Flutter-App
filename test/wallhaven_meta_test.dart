import 'package:flutter_test/flutter_test.dart';
import 'package:wallie_4k_wallpapers/data/models/wallhaven/wallhaven_meta.dart';

void main() {
  test('parses Wallhaven meta when per_page is a string', () {
    final meta = WallhavenMeta.fromJson({
      'current_page': 1,
      'last_page': 2630,
      'per_page': '24',
      'total': 63119,
    });

    expect(meta.perPage, 24);
    expect(meta.hasMore, isTrue);
  });
}
