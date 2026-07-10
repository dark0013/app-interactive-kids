import 'package:flutter/material.dart';
import '../../data/coloring_pages.dart';
import '../../theme/app_theme.dart';
import 'built_in_drawings.dart';
import 'coloring_game_screen.dart';

/// Galería: el niño elige qué dibujo quiere pintar.
class ColoringHomeScreen extends StatelessWidget {
  const ColoringHomeScreen({super.key});

  void _open(BuildContext context, ColoringPage page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ColoringGameScreen(page: page),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = ColoringPages.all;
    final assets = ColoringPages.assetImages;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          '🎨 Colorea y Pinta',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: CustomScrollView(
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
                        ? 'Pon tus imágenes en assets/coloring/ y regístralas en coloring_pages.dart. Mientras tanto puedes pintar estos dibujos.'
                        : 'Toca un dibujo para empezar a pintar con los dedos.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          if (assets.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text(
                  'Tus dibujos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            _grid(context, assets),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  'Más dibujos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ],
          _grid(
            context,
            assets.isNotEmpty ? ColoringPages.builtIn : pages,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
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
                  padding: const EdgeInsets.all(10),
                  child: widget.page.assetPath != null
                      ? Image.asset(
                          widget.page.assetPath!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, error, stackTrace) => Center(
                            child: Text(
                              widget.page.emoji,
                              style: const TextStyle(fontSize: 48),
                            ),
                          ),
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
                    Text(widget.page.emoji,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.page.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
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
