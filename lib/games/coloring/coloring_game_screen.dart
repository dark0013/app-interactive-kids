import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../data/coloring_pages.dart';
import '../../theme/app_theme.dart';
import 'blend_mask.dart';
import 'built_in_drawings.dart';
import 'paint_stroke.dart';

class ColoringGameScreen extends StatefulWidget {
  final ColoringPage page;

  const ColoringGameScreen({super.key, required this.page});

  @override
  State<ColoringGameScreen> createState() => _ColoringGameScreenState();
}

class _ColoringGameScreenState extends State<ColoringGameScreen> {
  static const _palette = <Color>[
    Color(0xFFE53935), // rojo
    Color(0xFFFF7043), // naranja
    Color(0xFFFFCA28), // amarillo
    Color(0xFF66BB6A), // verde
    Color(0xFF26C6DA), // cyan
    Color(0xFF42A5F5), // azul
    Color(0xFF7E57C2), // morado
    Color(0xFFEC407A), // rosa
    Color(0xFF8D6E63), // café
    Color(0xFF212121), // negro
    Color(0xFFFFFFFF), // blanco (pintar)
  ];

  final GlobalKey _canvasKey = GlobalKey();
  final List<PaintStroke> _strokes = [];
  final List<List<PaintStroke>> _undoStack = [];

  Color _color = const Color(0xFFE53935);
  double _brushSize = 28;
  bool _eraser = false;
  bool _saving = false;
  PaintStroke? _current;

  void _pushUndo() {
    _undoStack.add(
      _strokes
          .map(
            (s) => PaintStroke(
              points: List<Offset>.from(s.points),
              color: s.color,
              width: s.width,
              isEraser: s.isEraser,
            ),
          )
          .toList(),
    );
    if (_undoStack.length > 30) {
      _undoStack.removeAt(0);
    }
  }

  void _onStart(Offset local) {
    _pushUndo();
    _current = PaintStroke(
      points: [local],
      color: _color,
      width: _brushSize,
      isEraser: _eraser,
    );
    setState(() => _strokes.add(_current!));
  }

  void _onUpdate(Offset local) {
    if (_current == null) return;
    setState(() => _current!.points.add(local));
  }

  void _onEnd() {
    _current = null;
  }

  void _undo() {
    if (_undoStack.isEmpty) return;
    setState(() {
      _strokes
        ..clear()
        ..addAll(_undoStack.removeLast());
      _current = null;
    });
  }

  void _clear() {
    if (_strokes.isEmpty) return;
    _pushUndo();
    setState(() {
      _strokes.clear();
      _current = null;
    });
  }

  Future<void> _saveAsJpg() async {
    if (_saving) return;

    setState(() => _saving = true);
    try {
      // Deja que el frame actual termine de pintar el lienzo.
      await Future<void>.delayed(Duration.zero);
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        _showMessage('No se pudo capturar el dibujo', isError: true);
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();

      if (byteData == null) {
        _showMessage('No se pudo generar la imagen', isError: true);
        return;
      }

      final pngBytes = byteData.buffer.asUint8List();
      final decoded = img.decodePng(pngBytes);
      if (decoded == null) {
        _showMessage('No se pudo convertir a JPG', isError: true);
        return;
      }

      final jpgBytes = img.encodeJpg(decoded, quality: 92);
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'dibujo_$stamp';

      final result = await _persistJpg(jpgBytes, fileName);
      if (!mounted) return;

      if (result.ok) {
        _showMessage(result.message);
      } else {
        _showMessage(result.message, isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Error al guardar: $e', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Guarda en la galería (móvil) o en una carpeta del dispositivo (desktop).
  Future<({bool ok, String message})> _persistJpg(
    List<int> jpgBytes,
    String fileName,
  ) async {
    final bytes = Uint8List.fromList(jpgBytes);

    // Galería del teléfono / tablet
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      try {
        final hasAccess = await Gal.hasAccess(toAlbum: true);
        if (!hasAccess) {
          final granted = await Gal.requestAccess(toAlbum: true);
          if (!granted) {
            return (
              ok: false,
              message: 'Necesitamos permiso para guardar en la galería',
            );
          }
        }
        await Gal.putImageBytes(bytes, name: fileName);
        return (ok: true, message: '¡Dibujo guardado en la galería! 📷');
      } catch (_) {
        // Continúa con guardado en archivo
      }
    }

    // Desktop / fallback: carpeta de documentos o descargas
    if (kIsWeb) {
      return (ok: false, message: 'Guardar en web no está disponible aún');
    }

    try {
      Directory? dir;
      try {
        dir = await getDownloadsDirectory();
      } catch (_) {
        dir = null;
      }
      dir ??= await getApplicationDocumentsDirectory();

      final file = File('${dir.path}${Platform.pathSeparator}$fileName.jpg');
      await file.writeAsBytes(bytes, flush: true);
      return (ok: true, message: '¡Guardado!\n${file.path}');
    } catch (_) {
      return (ok: false, message: 'No se pudo guardar el dibujo');
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor:
            isError ? const Color(0xFFC62828) : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isError ? 4 : 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final isBlank = widget.page.isBlank;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        backgroundColor: AppTheme.netflixRed,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Text(widget.page.emoji),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.page.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Guardar JPG',
            onPressed: _saving ? null : _saveAsJpg,
            icon: _saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_alt_rounded),
          ),
          IconButton(
            tooltip: 'Deshacer',
            onPressed: _undoStack.isEmpty ? null : _undo,
            icon: const Icon(Icons.undo_rounded),
          ),
          IconButton(
            tooltip: 'Borrar todo',
            onPressed: _strokes.isEmpty ? null : _clear,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isBlank)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF90CAF9)),
              ),
              child: const Text(
                '✏️ Lienzo libre — dibuja lo que quieras',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
          // Lienzo
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.08),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (d) => _onStart(d.localPosition),
                      onPanUpdate: (d) => _onUpdate(d.localPosition),
                      onPanEnd: (_) => _onEnd(),
                      onPanCancel: _onEnd,
                      onTapDown: (d) {
                        _onStart(d.localPosition);
                        _onEnd();
                      },
                      child: RepaintBoundary(
                        key: _canvasKey,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            const ColoredBox(color: Colors.white),
                            // Pintura debajo del contorno
                            CustomPaint(
                              painter: StrokesPainter(strokes: _strokes),
                              size: Size(
                                constraints.maxWidth,
                                constraints.maxHeight,
                              ),
                            ),
                            // Contorno / imagen (no recibe toques)
                            if (!isBlank)
                              IgnorePointer(
                                child: _OutlineLayer(page: widget.page),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Controles
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12, 10, 12, 10 + bottomPad),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Guardar + grosor
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: _saving ? null : _saveAsJpg,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.netflixRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.download_rounded, size: 20),
                      label: Text(
                        _saving ? 'Guardando…' : 'Guardar JPG',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Grosor',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _brushSize,
                        min: 8,
                        max: 56,
                        activeColor: AppTheme.netflixRed,
                        onChanged: (v) => setState(() => _brushSize = v),
                      ),
                    ),
                    Container(
                      width: _brushSize.clamp(12, 36),
                      height: _brushSize.clamp(12, 36),
                      decoration: BoxDecoration(
                        color: _eraser ? Colors.grey.shade300 : _color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Paleta + borrador
                SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _ToolButton(
                        selected: _eraser,
                        onTap: () => setState(() => _eraser = true),
                        child: const Icon(Icons.auto_fix_off_rounded,
                            color: Color(0xFF555555)),
                      ),
                      const SizedBox(width: 8),
                      ..._palette.map((c) {
                        final selected = !_eraser && _color == c;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _ColorDot(
                            color: c,
                            selected: selected,
                            onTap: () => setState(() {
                              _eraser = false;
                              _color = c;
                            }),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineLayer extends StatelessWidget {
  final ColoringPage page;

  const _OutlineLayer({required this.page});

  @override
  Widget build(BuildContext context) {
    if (page.isBlank) {
      return const SizedBox.shrink();
    }

    if (page.assetPath != null) {
      // multiply: el blanco deja ver la pintura; las líneas negras se mantienen
      return BlendMask(
        blendMode: BlendMode.multiply,
        child: Image.asset(
          page.assetPath!,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return CustomPaint(
              painter: BuiltInDrawingPainter(
                drawingId: page.builtInId ?? 'star',
              ),
            );
          },
        ),
      );
    }

    return CustomPaint(
      painter: BuiltInDrawingPainter(
        drawingId: page.builtInId ?? 'star',
        strokeWidth: 5,
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isWhite = color.computeLuminance() > 0.9;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: selected ? 48 : 42,
        height: selected ? 48 : 42,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? AppTheme.netflixRed
                : (isWhite ? Colors.black26 : Colors.black12),
            width: selected ? 3.5 : 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  const _ToolButton({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFEBEE) : const Color(0xFFF5F5F5),
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppTheme.netflixRed : Colors.black12,
            width: selected ? 3 : 1.5,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
