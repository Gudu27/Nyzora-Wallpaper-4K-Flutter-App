import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

final colorExtractorProvider = Provider<ColorExtractor>((ref) {
  return const ColorExtractor();
});

class ColorExtractor {
  const ColorExtractor();

  Future<Color?> extractDominantColor(ImageProvider provider) async {
    try {
      final palette = await PaletteGenerator.fromImageProvider(
        provider,
        maximumColorCount: 8,
      );
      return palette.dominantColor?.color ??
          palette.vibrantColor?.color ??
          palette.mutedColor?.color;
    } catch (_) {
      return null;
    }
  }

  Future<Color?> extractFromUrl(String imageUrl) async {
    return extractDominantColor(NetworkImage(imageUrl));
  }

  Color hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF7C3AED);
    var value = hex.replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    try {
      return Color(int.parse(value, radix: 16));
    } catch (_) {
      return const Color(0xFF7C3AED);
    }
  }
}
