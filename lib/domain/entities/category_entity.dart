import 'package:flutter/material.dart';

class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.emoji,
    required this.gradientKey,
    required this.wallhavenQuery,
    this.unsplashTopic,
  });

  final String id;
  final String name;
  final String emoji;
  final String gradientKey;
  final String wallhavenQuery;
  final String? unsplashTopic;

  LinearGradient get gradient {
    final colors = _gradientColors[gradientKey] ?? _gradientColors['abstract']!;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  static const Map<String, List<Color>> _gradientColors = {
    'nature': [Color(0xFF134E5E), Color(0xFF71B280)],
    'space': [Color(0xFF0F0C29), Color(0xFF302B63)],
    'abstract': [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    'animals': [Color(0xFF1A3A1A), Color(0xFF2D6A2D)],
    'city': [Color(0xFF1C1C2E), Color(0xFF3D3D5C)],
    'fantasy': [Color(0xFF2D1B69), Color(0xFF6B3FA0)],
    'minimal': [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
    'dark': [Color(0xFF000000), Color(0xFF0D0D0D)],
    'neon': [Color(0xFF0D0221), Color(0xFF1A0533)],
    'architecture': [Color(0xFF1A1215), Color(0xFF3D1A28)],
    'ocean': [Color(0xFF0C3547), Color(0xFF1A6B8A)],
    'mountains': [Color(0xFF1B2838), Color(0xFF2A3F5F)],
    'flowers': [Color(0xFF2D1B1B), Color(0xFF6B2D3E)],
    'cars': [Color(0xFF0D0D0D), Color(0xFF1A1A2E)],
    'japanese': [Color(0xFF2D1515), Color(0xFF8B3A3A)],
    'patterns': [Color(0xFF1A0D2E), Color(0xFF3D1A5C)],
    'weather': [Color(0xFF0D1B2A), Color(0xFF1A3A5C)],
    'sunsets': [Color(0xFF2D1515), Color(0xFF8B4513)],
  };

  static List<CategoryEntity> get all => const [
        CategoryEntity(
          id: 'nature',
          name: 'Nature',
          emoji: '🌿',
          gradientKey: 'nature',
          wallhavenQuery: 'nature landscape',
          unsplashTopic: 'nature',
        ),
        CategoryEntity(
          id: 'space',
          name: 'Space',
          emoji: '🌌',
          gradientKey: 'space',
          wallhavenQuery: 'space galaxy',
        ),
        CategoryEntity(
          id: 'abstract',
          name: 'Abstract',
          emoji: '🎨',
          gradientKey: 'abstract',
          wallhavenQuery: 'abstract',
          unsplashTopic: 'textures-patterns',
        ),
        CategoryEntity(
          id: 'animals',
          name: 'Animals',
          emoji: '🦁',
          gradientKey: 'animals',
          wallhavenQuery: 'animals wildlife',
          unsplashTopic: 'animals',
        ),
        CategoryEntity(
          id: 'city',
          name: 'City',
          emoji: '🏙️',
          gradientKey: 'city',
          wallhavenQuery: 'city urban',
          unsplashTopic: 'street-photography',
        ),
        CategoryEntity(
          id: 'fantasy',
          name: 'Fantasy',
          emoji: '🐉',
          gradientKey: 'fantasy',
          wallhavenQuery: 'fantasy art',
          unsplashTopic: 'experimental',
        ),
        CategoryEntity(
          id: 'minimal',
          name: 'Minimal',
          emoji: '◻️',
          gradientKey: 'minimal',
          wallhavenQuery: 'minimal simple',
        ),
        CategoryEntity(
          id: 'dark',
          name: 'Dark',
          emoji: '🌑',
          gradientKey: 'dark',
          wallhavenQuery: 'dark black',
        ),
        CategoryEntity(
          id: 'neon',
          name: 'Neon',
          emoji: '✨',
          gradientKey: 'neon',
          wallhavenQuery: 'neon cyberpunk',
          unsplashTopic: 'experimental',
        ),
        CategoryEntity(
          id: 'architecture',
          name: 'Architecture',
          emoji: '🏛️',
          gradientKey: 'architecture',
          wallhavenQuery: 'architecture building',
          unsplashTopic: 'architecture-interior',
        ),
        CategoryEntity(
          id: 'ocean',
          name: 'Ocean',
          emoji: '🌊',
          gradientKey: 'ocean',
          wallhavenQuery: 'ocean sea beach',
          unsplashTopic: 'travel',
        ),
        CategoryEntity(
          id: 'mountains',
          name: 'Mountains',
          emoji: '🏔️',
          gradientKey: 'mountains',
          wallhavenQuery: 'mountains alpine',
          unsplashTopic: 'wallpapers',
        ),
        CategoryEntity(
          id: 'flowers',
          name: 'Flowers',
          emoji: '🌸',
          gradientKey: 'flowers',
          wallhavenQuery: 'flowers floral',
        ),
        CategoryEntity(
          id: 'cars',
          name: 'Cars',
          emoji: '🚗',
          gradientKey: 'cars',
          wallhavenQuery: 'cars automotive',
        ),
        CategoryEntity(
          id: 'japanese',
          name: 'Japanese',
          emoji: '🎌',
          gradientKey: 'japanese',
          wallhavenQuery: 'japan anime',
        ),
        CategoryEntity(
          id: 'patterns',
          name: 'Patterns',
          emoji: '🌀',
          gradientKey: 'patterns',
          wallhavenQuery: 'pattern geometric',
          unsplashTopic: 'textures-patterns',
        ),
        CategoryEntity(
          id: 'weather',
          name: 'Weather',
          emoji: '⛈️',
          gradientKey: 'weather',
          wallhavenQuery: 'storm clouds weather',
        ),
        CategoryEntity(
          id: 'sunsets',
          name: 'Sunsets',
          emoji: '🌅',
          gradientKey: 'sunsets',
          wallhavenQuery: 'sunset golden hour',
        ),
      ];
}
