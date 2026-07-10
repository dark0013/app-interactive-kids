# KIDS+ — Menú interactivo estilo Netflix

App Flutter con una interfaz de streaming inspirada en Netflix, orientada a contenido infantil.

## Características

- **Banner hero** con carrusel automático, botones Reproducir / Más info / Mi lista
- **Filas horizontales** de contenido (destacados, novedades, aventuras, etc.)
- **Tarjetas interactivas** con hover/scale y overlay de play
- **Navegación superior** por categorías (Inicio, Series, Películas, Juegos, Aprender, Mi Lista)
- **Búsqueda** en tiempo real por título, género o etiquetas
- **Pantalla de detalle** con sinopsis, etiquetas y episodios/lecciones
- **Selector de perfiles** estilo Netflix
- **Tabs inferiores**: Inicio, Próximamente, Descargas
- Tema oscuro con acento rojo Netflix

## Ejecutar

```bash
flutter pub get
flutter run
```

Para web:

```bash
flutter run -d chrome
```

Para Windows:

```bash
flutter run -d windows
```

## Estructura

```
lib/
  main.dart
  data/mock_data.dart          # Contenido de ejemplo
  models/content_item.dart     # Modelos
  theme/app_theme.dart         # Tema oscuro
  screens/
    home_screen.dart
    detail_screen.dart
  widgets/
    hero_banner.dart
    content_card.dart
    content_row.dart
    top_nav_bar.dart
    search_overlay.dart
```
