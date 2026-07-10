import 'dart:async';

import 'package:flutter/material.dart';
import '../models/content_item.dart';
import '../theme/app_theme.dart';

class HeroBanner extends StatefulWidget {
  final List<ContentItem> items;
  final void Function(ContentItem item) onPlay;
  final void Function(ContentItem item) onInfo;
  final void Function(ContentItem item) onMyList;

  const HeroBanner({
    super.key,
    required this.items,
    required this.onPlay,
    required this.onInfo,
    required this.onMyList,
  });

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  int _current = 0;
  Timer? _timer;
  final Set<String> _myListIds = {};

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.items.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      setState(() {
        _current = (_current + 1) % widget.items.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  ContentItem get _item => widget.items[_current];

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final size = MediaQuery.sizeOf(context);
    final height = size.height * 0.55;
    final isWide = size.width > 700;

    return SizedBox(
      height: height.clamp(360.0, 520.0),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: DecoratedBox(
              key: ValueKey(_item.id),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _item.gradientColors.map((c) => Color(c)).toList(),
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Opacity(
                      opacity: 0.25,
                      child: Text(
                        _item.emoji,
                        style: TextStyle(fontSize: isWide ? 200 : 140),
                      ),
                    ),
                  ),
                  // Vignette
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.35),
                          AppTheme.background.withValues(alpha: 0.85),
                          AppTheme.background,
                        ],
                        stops: const [0.0, 0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Positioned(
            left: isWide ? 48 : 20,
            right: isWide ? size.width * 0.35 : 20,
            bottom: isWide ? 64 : 48,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Column(
                key: ValueKey('info-${_item.id}'),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_item.isNew)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.netflixRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'NUEVO',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  Text(
                    _item.title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: isWide ? 40 : 28,
                          shadows: const [
                            Shadow(color: Colors.black54, blurRadius: 12),
                          ],
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFD54F), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        _item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        _item.category,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '+${_item.ageRating} años',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          _item.isPlayable ? 'Listo para jugar' : 'Próximamente',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _item.description,
                    maxLines: isWide ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: isWide ? 16 : 14,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => widget.onPlay(_item),
                        icon: const Icon(Icons.sports_esports_rounded, size: 26),
                        label: Text(_item.playLabel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 12,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => widget.onInfo(_item),
                        icon: const Icon(Icons.info_outline_rounded, size: 22),
                        label: const Text('Más info'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.15),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (_myListIds.contains(_item.id)) {
                              _myListIds.remove(_item.id);
                            } else {
                              _myListIds.add(_item.id);
                            }
                          });
                          widget.onMyList(_item);
                        },
                        icon: Icon(
                          _myListIds.contains(_item.id)
                              ? Icons.check_rounded
                              : Icons.add_rounded,
                          size: 22,
                        ),
                        label: Text(
                          _myListIds.contains(_item.id)
                              ? 'En mi lista'
                              : 'Mi lista',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.15),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Dots
          if (widget.items.length > 1)
            Positioned(
              right: 20,
              bottom: 28,
              child: Row(
                children: List.generate(widget.items.length, (i) {
                  final active = i == _current;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _current = i);
                      _startAutoPlay();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
