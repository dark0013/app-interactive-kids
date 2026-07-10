import '../models/content_item.dart';

/// Catálogo del menú: solo juegos infantiles.
/// Por ahora solo "Colorear" está implementado; el resto muestra "Próximamente".
class MockData {
  static const List<ContentItem> allContent = [
    ContentItem(
      id: 'coloring',
      title: 'Colorea y Pinta',
      description:
          'Elige un dibujo y píntalo con tus dedos. ¡Hay muchos colores y pinceles divertidos!',
      category: 'Arte',
      gameId: GameId.coloring,
      ageRating: 3,
      rating: 5.0,
      tags: ['Colorear', 'Dibujar', 'Creatividad'],
      gradientColors: [0xFFE91E63, 0xFFFF9800, 0xFFFFEB3B],
      emoji: '🎨',
      isFeatured: true,
      isNew: true,
      playLabel: '¡A colorear!',
    ),
    ContentItem(
      id: 'memory',
      title: 'Memoria Mágica',
      description:
          'Encuentra las parejas de cartas. Entrena tu memoria con animales y formas.',
      category: 'Memoria',
      gameId: GameId.comingSoon,
      ageRating: 4,
      rating: 4.8,
      tags: ['Memoria', 'Parejas', 'Animales'],
      gradientColors: [0xFF7C4DFF, 0xFF536DFE, 0xFF18FFFF],
      emoji: '🃏',
      isFeatured: true,
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'puzzle',
      title: 'Puzzle Amigos',
      description:
          'Arma rompecabezas fáciles con piezas grandes. Perfecto para manos pequeñas.',
      category: 'Puzzle',
      gameId: GameId.comingSoon,
      ageRating: 3,
      rating: 4.7,
      tags: ['Puzzle', 'Formas', 'Tranquilo'],
      gradientColors: [0xFF00897B, 0xFF26A69A, 0xFFB2FF59],
      emoji: '🧩',
      isFeatured: true,
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'numbers',
      title: 'Números Felices',
      description:
          'Cuenta estrellas, manzanas y globos. Aprende números jugando.',
      category: 'Aprender',
      gameId: GameId.comingSoon,
      ageRating: 4,
      rating: 4.9,
      tags: ['Números', 'Contar', 'Educativo'],
      gradientColors: [0xFF1565C0, 0xFF42A5F5, 0xFF80D8FF],
      emoji: '🔢',
      isNew: true,
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'letters',
      title: 'ABC Divertido',
      description:
          'Descubre las letras del abecedario con sonidos y dibujos alegres.',
      category: 'Aprender',
      gameId: GameId.comingSoon,
      ageRating: 4,
      rating: 4.8,
      tags: ['Letras', 'ABC', 'Educativo'],
      gradientColors: [0xFF6A1B9A, 0xFFAB47BC, 0xFFF48FB1],
      emoji: '🔤',
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'animals',
      title: 'Sonidos de Animales',
      description:
          'Toca cada animal y escucha cómo hace. ¿Cómo hace la vaca? ¡Muuu!',
      category: 'Animales',
      gameId: GameId.comingSoon,
      ageRating: 2,
      rating: 4.9,
      tags: ['Animales', 'Sonidos', 'Bebés'],
      gradientColors: [0xFF2E7D32, 0xFF81C784, 0xFFFFF176],
      emoji: '🐶',
      isFeatured: true,
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'shapes',
      title: 'Formas Mágicas',
      description:
          'Círculos, cuadrados y triángulos. Arrastra y encaja las formas correctas.',
      category: 'Aprender',
      gameId: GameId.comingSoon,
      ageRating: 3,
      rating: 4.6,
      tags: ['Formas', 'Colores', 'Encajar'],
      gradientColors: [0xFFEF6C00, 0xFFFFA726, 0xFFFFECB3],
      emoji: '⭐',
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'music',
      title: 'Banda Musical',
      description:
          'Toca el piano, el tambor y la guitarra. Crea tu propia canción.',
      category: 'Música',
      gameId: GameId.comingSoon,
      ageRating: 3,
      rating: 4.7,
      tags: ['Música', 'Instrumentos', 'Ritmo'],
      gradientColors: [0xFFAD1457, 0xFFEC407A, 0xFFFF80AB],
      emoji: '🎵',
      isNew: true,
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'bubbles',
      title: 'Explota Burbujas',
      description:
          'Toca las burbujas de colores antes de que se vayan. ¡Rápido y divertido!',
      category: 'Acción suave',
      gameId: GameId.comingSoon,
      ageRating: 2,
      rating: 4.5,
      tags: ['Burbujas', 'Tocar', 'Colores'],
      gradientColors: [0xFF0277BD, 0xFF4FC3F7, 0xFFE1F5FE],
      emoji: '🫧',
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'farm',
      title: 'Mi Granja',
      description:
          'Cuida a los animalitos de la granja: dales de comer y hazlos felices.',
      category: 'Cuidado',
      gameId: GameId.comingSoon,
      ageRating: 3,
      rating: 4.8,
      tags: ['Granja', 'Animales', 'Cuidar'],
      gradientColors: [0xFF558B2F, 0xFFAED581, 0xFFFFF59D],
      emoji: '🐄',
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'cars',
      title: 'Carrera de Colores',
      description:
          'Elige un carrito de color y corre por pistas fáciles y alegres.',
      category: 'Carreras',
      gameId: GameId.comingSoon,
      ageRating: 4,
      rating: 4.4,
      tags: ['Carros', 'Carrera', 'Colores'],
      gradientColors: [0xFFC62828, 0xFFEF5350, 0xFFFFCDD2],
      emoji: '🚗',
      playLabel: 'Próximamente',
    ),
    ContentItem(
      id: 'stars',
      title: 'Atrapa Estrellas',
      description:
          'Mueve tu nave y recoge estrellas brillantes en el cielo nocturno.',
      category: 'Aventura',
      gameId: GameId.comingSoon,
      ageRating: 5,
      rating: 4.6,
      tags: ['Espacio', 'Estrellas', 'Nave'],
      gradientColors: [0xFF1A237E, 0xFF5C6BC0, 0xFFFFD54F],
      emoji: '🌟',
      isNew: true,
      playLabel: 'Próximamente',
    ),
  ];

  static List<ContentItem> get featured =>
      allContent.where((c) => c.isFeatured).toList();

  static List<ContentItem> get newGames =>
      allContent.where((c) => c.isNew).toList();

  static List<ContentItem> get playable =>
      allContent.where((c) => c.isPlayable).toList();

  static List<ContentRow> get rows => [
        ContentRow(
          title: '¡Juega ahora!',
          items: playable,
        ),
        ContentRow(
          title: 'Destacados',
          items: featured,
        ),
        ContentRow(
          title: 'Nuevos juegos',
          items: newGames,
        ),
        ContentRow(
          title: 'Arte y creatividad',
          items: allContent
              .where((c) =>
                  c.category == 'Arte' || c.tags.contains('Creatividad'))
              .toList(),
        ),
        ContentRow(
          title: 'Aprende jugando',
          items: allContent.where((c) => c.category == 'Aprender').toList(),
        ),
        ContentRow(
          title: 'Animales y naturaleza',
          items: allContent
              .where((c) =>
                  c.category == 'Animales' ||
                  c.category == 'Cuidado' ||
                  c.tags.contains('Animales'))
              .toList(),
        ),
        ContentRow(
          title: 'Música y movimiento',
          items: allContent
              .where((c) =>
                  c.category == 'Música' || c.tags.contains('Ritmo'))
              .toList(),
        ),
        ContentRow(
          title: 'Todos los juegos',
          items: allContent,
        ),
      ];

  static List<String> get categories => [
        'Inicio',
        'Jugar',
        'Aprender',
        'Arte',
        'Animales',
        'Mi Lista',
      ];
}
