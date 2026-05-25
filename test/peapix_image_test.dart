import 'package:flutter_test/flutter_test.dart';
import 'package:wallie_4k_wallpapers/data/models/peapix/peapix_image.dart';

void main() {
  test('parses live Peapix Bing JSON shape', () {
    final image = PeapixImage.fromJson({
      'title': 'View over Jaipur',
      'fullUrl': 'https://img.peapix.com/c6dec449ea9c4ced91e70406d11c0cc5_1920.jpg',
      'thumbUrl': 'https://img.peapix.com/c6dec449ea9c4ced91e70406d11c0cc5_640.jpg',
      'imageUrl': 'https://img.peapix.com/c6dec449ea9c4ced91e70406d11c0cc5.jpg',
      'pageUrl': 'https://peapix.com/bing/56232',
      'date': '2026-05-25',
    }, 'bing');

    expect(PeapixImage.hasValidUrl(image.imageUrl), isTrue);
    expect(image.id, '56232');
    expect(image.thumbnailUrl, contains('_640.jpg'));

    final entity = image.toEntity();
    expect(entity.fullUrl, contains('_1920.jpg'));
    expect(entity.thumbnailUrl, contains('_640.jpg'));
  });
}
