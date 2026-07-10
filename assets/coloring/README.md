# Dibujos para colorear

Coloca aquí las imágenes que el niño podrá pintar en el juego **Colorea y Pinta**.

## Formato recomendado

- **PNG** (preferido) o **JPG**
- Dibujo de **líneas negras** sobre fondo **blanco** o **transparente**
- Tamaño sugerido: 800×800 o 1024×1024 px
- Nombre simple, sin espacios: `gato.png`, `casa.png`, `dinosaurio.png`

## Pasos

1. Copia tu imagen en esta carpeta, por ejemplo:
   ```
   assets/coloring/gato.png
   ```
2. Abre `lib/data/coloring_pages.dart` y agrega la página en `assetImages`:
   ```dart
   ColoringPage(
     id: 'gato',
     title: 'Gato',
     emoji: '🐱',
     assetPath: 'assets/coloring/gato.png',
   ),
   ```
3. En la terminal:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
4. En la app: **Colorea y Pinta** → elige tu dibujo → pinta con el dedo.

## Nota

La carpeta ya está registrada en `pubspec.yaml` como:

```yaml
assets:
  - assets/coloring/
```

Si la carpeta solo tiene este README, la app usa dibujos integrados (casita, sol, pez, etc.) hasta que agregues imágenes.
