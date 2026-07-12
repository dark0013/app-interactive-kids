import 'package:flutter/material.dart';
import '../../data/coloring_pages.dart';
import '../../theme/app_theme.dart';
import 'built_in_drawings.dart';
import 'coloring_game_screen.dart';

/// Galería: el niño elige qué dibujo quiere pintar.
/// Las imágenes de assets/coloring/ se cargan solas (cualquier formato).
class ColoringHomeScreen extends StatefulWidget {
  const ColoringHomeScreen({super.key});

  @override
  State<ColoringHomeScreen> createState() => _ColoringHomeScreenState();
}

class _ColoringHomeScreenState extends State<ColoringHomeScreen> {
  late Future<({List<ColoringPage> assets, List<ColoringPage> all})> _future;

  @override
  void initState() {
    super.initState();
    _future = ColoringPages.loadAll();
  }

  Future<void> _reload() async {
    setState(() {
      _future = ColoringPages.loadAll(forceReload: true);
    });
    await _future;
  }

  void _open(BuildContext context, ColoringPage page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ColoringGameScreen(page: page),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          '🎨 Colorea y Pinta',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar dibujos',
            onPressed: _reload,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: FutureBuilder<({List<ColoringPage> assets, List<ColoringPage> all})>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.netflixRed),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('😕', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      'No se pudieron cargar los dibujos',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final assets = snapshot.data?.assets ?? const <ColoringPage>[];

          return RefreshIndicator(
            color: AppTheme.netflixRed,
            onRefresh: _reload,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Elige un dibujo',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          assets.isEmpty
                              ? 'Pon imágenes en assets/coloring/ (jpg, png, gif, webp…) y reinicia la app.'
                              : '${assets.length} dibujos listos. Toca uno para pintar.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                // Lienzo en blanco destacado
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: _BlankCanvasCard(
                      onTap: () => _open(context, ColoringPages.blankCanvas),
                    ),
                  ),
                ),
                if (assets.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                      child: Text(
                        'Tus dibujos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  _grid(context, assets),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _grid(BuildContext context, List<ColoringPage> pages) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final page = pages[index];
            return _PageCard(
              page: page,
              onTap: () => _open(context, page),
            );
          },
          childCount: pages.length,
        ),
      ),
    );
  }
}

/// Tarjeta grande para dibujar libremente en un lienzo vacío.
class _BlankCanvasCard extends StatefulWidget {
  final VoidCallback onTap;

  const _BlankCanvasCard({required this.onTap});

  @override
  State<_BlankCanvasCard> createState() => _BlankCanvasCardState();
}

class _BlankCanvasCardState extends State<_BlankCanvasCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF8E7), Color(0xFFFFE0B2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.netflixRed.withValues(alpha: 0.45), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('✏️', style: TextStyle(fontSize: 34)),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lienzo en blanco',
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Dibuja libremente lo que imagines',
                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppTheme.netflixRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.brush_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageCard extends StatefulWidget {
  final ColoringPage page;
  final VoidCallback onTap;

  const _PageCard({required this.page, required this.onTap});

  @override
  State<_PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<_PageCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: widget.page.assetPath != null
                      ? Image.asset(
                          widget.page.assetPath!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Formato no soportado por el motor (p. ej. AVIF en algunos SO)
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.page.emoji,
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Toca para intentar',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black.withValues(alpha: 0.45),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : CustomPaint(
                          painter: BuiltInDrawingPainter(
                            drawingId: widget.page.builtInId ?? 'star',
                            strokeWidth: 3.5,
                          ),
                        ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      widget.page.emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.page.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.brush_rounded,
                      color: AppTheme.netflixRed,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
