import 'package:flutter/material.dart';
import '../models/content_item.dart';
import '../navigation/game_router.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatefulWidget {
  final ContentItem item;

  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _inMyList = false;
  bool _liked = false;

  ContentItem get item => widget.item;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 700;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.4,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: Colors.black.withValues(alpha: 0.45),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors:
                            item.gradientColors.map((c) => Color(c)).toList(),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      item.emoji,
                      style: TextStyle(fontSize: isWide ? 140 : 100),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.background.withValues(alpha: 0.4),
                          AppTheme.background,
                        ],
                        stops: const [0.4, 0.75, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 48 : 20,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: isWide ? 36 : 28,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFD54F), size: 20),
                          const SizedBox(width: 4),
                          Text(
                            item.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      _Badge(label: 'Juego'),
                      _Badge(label: item.category),
                      _Badge(label: '+${item.ageRating} años'),
                      if (item.isPlayable)
                        const _Badge(label: 'Listo para jugar')
                      else
                        const _Badge(label: 'Próximamente'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => GameRouter.open(context, item),
                      icon: Icon(
                        item.isPlayable
                            ? Icons.play_arrow_rounded
                            : Icons.schedule_rounded,
                        size: 28,
                      ),
                      label: Text(item.playLabel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.isPlayable
                            ? Colors.white
                            : Colors.white24,
                        foregroundColor:
                            item.isPlayable ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionChip(
                        icon: _inMyList
                            ? Icons.check_rounded
                            : Icons.add_rounded,
                        label: _inMyList ? 'En lista' : 'Mi lista',
                        onTap: () {
                          setState(() => _inMyList = !_inMyList);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _inMyList
                                    ? '“${item.title}” en Mi lista'
                                    : 'Quitado de Mi lista',
                              ),
                              backgroundColor: AppTheme.surface,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      _ActionChip(
                        icon: _liked
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        label: 'Me gusta',
                        onTap: () => setState(() => _liked = !_liked),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Sobre el juego',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.55,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Etiquetas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: AppTheme.cardDark,
                        side: BorderSide.none,
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white38),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
