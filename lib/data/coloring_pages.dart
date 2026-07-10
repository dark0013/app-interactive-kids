/// Páginas para el juego de colorear.
///
/// Cómo agregar tus dibujos:
/// 1. Copia imágenes PNG o JPG en: assets/coloring/
///    (ideal: dibujo de líneas negras sobre fondo blanco o transparente)
/// 2. Añade el nombre del archivo en [assetImages] abajo.
/// 3. Ejecuta: flutter pub get
/// 4. Reinicia la app (hot restart).
class ColoringPage {
  final String id;
  final String title;
  final String emoji;

  /// Ruta del asset, ej: assets/coloring/gato.png
  /// Si es null, se usa un dibujo integrado de la app.
  final String? assetPath;

  /// Clave del dibujo integrado (solo si [assetPath] es null).
  final String? builtInId;

  const ColoringPage({
    required this.id,
    required this.title,
    required this.emoji,
    this.assetPath,
    this.builtInId,
  });

  bool get isAsset => assetPath != null;
}

class ColoringPages {
  /// ⬇️ Agrega aquí tus archivos de assets/coloring/
  /// Ejemplo:
  ///   ColoringPage(
  ///     id: 'gato',
  ///     title: 'Gato',
  ///     emoji: '🐱',
  ///     assetPath: 'assets/coloring/gato.png',
  ///   ),
  static const List<ColoringPage> assetImages = [
    ColoringPage(
      id: 'capibara',
      title: 'Capibara',
      emoji: '🦫',
      assetPath:
          'assets/coloring/Dibujos-para-colorear-de-Capibara-1.jpg',
    ),
    // Agrega más imágenes aquí:
    // ColoringPage(
    //   id: 'gato',
    //   title: 'Gato',
    //   emoji: '🐱',
    //   assetPath: 'assets/coloring/gato.png',
    // ),
  ];

  /// Dibujos incluidos (vectoriales) además de tus imágenes.
  static const List<ColoringPage> builtIn = [
    ColoringPage(
      id: 'house',
      title: 'Casita',
      emoji: '🏠',
      builtInId: 'house',
    ),
    ColoringPage(
      id: 'sun',
      title: 'Sol feliz',
      emoji: '☀️',
      builtInId: 'sun',
    ),
    ColoringPage(
      id: 'fish',
      title: 'Pez',
      emoji: '🐟',
      builtInId: 'fish',
    ),
    ColoringPage(
      id: 'flower',
      title: 'Flor',
      emoji: '🌸',
      builtInId: 'flower',
    ),
    ColoringPage(
      id: 'car',
      title: 'Carrito',
      emoji: '🚗',
      builtInId: 'car',
    ),
    ColoringPage(
      id: 'star',
      title: 'Estrella',
      emoji: '⭐',
      builtInId: 'star',
    ),
  ];

  static List<ColoringPage> get all => [...assetImages, ...builtIn];
}
