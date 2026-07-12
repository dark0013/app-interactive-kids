import 'package:flutter/services.dart';

/// Una página del juego de colorear (imagen de assets o dibujo integrado).
class ColoringPage {
  final String id;
  final String title;
  final String emoji;

  /// Ruta del asset, ej: assets/coloring/gato.png
  final String? assetPath;

  /// Clave del dibujo integrado (solo si [assetPath] es null).
  final String? builtInId;

  /// Lienzo vacío para dibujar libremente (sin contorno).
  final bool isBlank;

  const ColoringPage({
    required this.id,
    required this.title,
    required this.emoji,
    this.assetPath,
    this.builtInId,
    this.isBlank = false,
  });

  bool get isAsset => assetPath != null;
}

/// Carga automáticamente **todas** las imágenes de `assets/coloring/`
/// sin importar la extensión (.jpg, .png, .gif, .webp, .avif, .bmp, …).
///
/// Cómo agregar dibujos:
/// 1. Copia la imagen en `assets/coloring/`
/// 2. Ejecuta `flutter pub get` y reinicia la app (hot restart)
/// 3. Aparecerá sola en la galería (no hace falta editar código)
class ColoringPages {
  static const _folder = 'assets/coloring/';

  /// Extensiones de imagen reconocidas (cualquier formato de esta lista).
  static const imageExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.bmp',
    '.avif',
    '.heic',
    '.heif',
    '.tga',
    '.wbmp',
  };

  /// Títulos y emojis amigables según el nombre del archivo.
  static const Map<String, (String title, String emoji)> _knownNames = {
    'dibujos-para-colorear-de-capibara-1': ('Capibara', '🦫'),
    'bebe-tiburon-con-submarino-y-pinkfong': (
      'Bebé tiburón y Pinkfong',
      '🦈',
    ),
    'dibujo-de-tiburon-bebe': ('Tiburón bebé', '🦈'),
    'dibujos-para-colorear-de-doraemon-016': ('Doraemon', '🤖'),
    'dibujos_para_colorear_wk_baby_shark_by_dibujosparacolorear_dg4lwpl-fullview':
        ('Baby Shark', '🦈'),
    'divertidas-caricaturas-dinosaurios-colorear_515272-468': (
      'Dinosaurios',
      '🦕',
    ),
    'how-to-draw-ninimo-from-pinkfong-step-7': ('Ninimo', '🦊'),
    'imprimir-para-colorear-doraemon-8': ('Doraemon sonríe', '🤖'),
    'pinkfong-kawaii': ('Pinkfong Kawaii', '🦊'),
    'pinkfong-montando-un-tiburon-bebe': ('Pinkfong en tiburón', '🦈'),
    'tiburon-lindo-bebe': ('Tiburón lindo', '🦈'),
    'wonder-day-plim-plim-coloring-pages-14': ('Plim Plim 1', '🎪'),
    'wonder-day-plim-plim-coloring-pages-6': ('Plim Plim 2', '🎪'),
  };

  /// Lienzo vacío para dibujo libre.
  static const ColoringPage blankCanvas = ColoringPage(
    id: 'blank',
    title: 'Lienzo en blanco',
    emoji: '✏️',
    isBlank: true,
  );

  /// Dibujos vectoriales de la app (siempre disponibles).
  static const List<ColoringPage> builtIn = [
    blankCanvas,
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

  /// Lista en caché tras la primera carga.
  static List<ColoringPage>? _cachedAssets;

  /// Carga (o reutiliza) todas las imágenes de assets/coloring/.
  static Future<List<ColoringPage>> loadAssetImages({
    bool forceReload = false,
  }) async {
    if (!forceReload && _cachedAssets != null) {
      return _cachedAssets!;
    }

    final manifest =
        await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) => p.startsWith(_folder))
        .where(_isImageAsset)
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    _cachedAssets = [
      for (var i = 0; i < paths.length; i++) _pageFromPath(paths[i], i),
    ];
    return _cachedAssets!;
  }

  /// Imágenes de assets + dibujos integrados.
  static Future<({List<ColoringPage> assets, List<ColoringPage> all})>
      loadAll({bool forceReload = false}) async {
    final assets = await loadAssetImages(forceReload: forceReload);
    return (assets: assets, all: [...assets, ...builtIn]);
  }

  static bool _isImageAsset(String path) {
    final name = path.split('/').last.toLowerCase();
    // Ignorar docs y archivos ocultos
    if (name.startsWith('.') ||
        name == 'readme.md' ||
        name.endsWith('.md') ||
        name.endsWith('.txt') ||
        name.endsWith('.gitkeep')) {
      return false;
    }
    final dot = name.lastIndexOf('.');
    if (dot < 0) return false;
    return imageExtensions.contains(name.substring(dot));
  }

  static ColoringPage _pageFromPath(String path, int index) {
    final fileName = path.split('/').last;
    final base = _stripExtension(fileName);
    final key = base.toLowerCase();

    final known = _knownNames[key];
    if (known != null) {
      return ColoringPage(
        id: 'asset_$key',
        title: known.$1,
        emoji: known.$2,
        assetPath: path,
      );
    }

    // Nombre legible desde el archivo
    final title = _humanize(base);
    return ColoringPage(
      id: 'asset_${key.hashCode.abs()}',
      title: title.isEmpty ? 'Dibujo ${index + 1}' : title,
      emoji: _emojiFor(key),
      assetPath: path,
    );
  }

  static String _stripExtension(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot <= 0) return fileName;
    return fileName.substring(0, dot);
  }

  static String _humanize(String base) {
    var s = base
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // Quitar basura de nombres largos / hashes
    if (RegExp(r'^[a-f0-9]{16,}$', caseSensitive: false).hasMatch(s)) {
      return '';
    }
    if (s.length > 40) {
      s = s.substring(0, 40).trim();
    }

    // Prefijos típicos de descargas
    s = s
        .replaceAll(
          RegExp(
            r'^(dibujos?\s*para\s*colorear\s*(de\s*)?)',
            caseSensitive: false,
          ),
          '',
        )
        .replaceAll(
          RegExp(r'^(imprimir\s*para\s*colorear\s*)', caseSensitive: false),
          '',
        )
        .replaceAll(
          RegExp(r'^(how\s*to\s*draw\s*)', caseSensitive: false),
          '',
        )
        .trim();

    if (s.isEmpty) return '';

    return s
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) {
          if (w.length == 1) return w.toUpperCase();
          return '${w[0].toUpperCase()}${w.substring(1)}';
        })
        .join(' ');
  }

  static String _emojiFor(String key) {
    if (key.contains('capibara') || key.contains('capybara')) return '🦫';
    if (key.contains('tiburon') ||
        key.contains('shark') ||
        key.contains('baby_shark') ||
        key.contains('baby-shark')) {
      return '🦈';
    }
    if (key.contains('doraemon')) return '🤖';
    if (key.contains('dino')) return '🦕';
    if (key.contains('pinkfong') ||
        key.contains('ninimo') ||
        key.contains('fox')) {
      return '🦊';
    }
    if (key.contains('plim')) return '🎪';
    if (key.contains('flor') || key.contains('flower')) return '🌸';
    if (key.contains('sol') || key.contains('sun')) return '☀️';
    if (key.contains('estrella') || key.contains('star')) return '⭐';
    return '🎨';
  }
}
