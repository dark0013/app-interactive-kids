import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/content_item.dart';
import '../navigation/game_router.dart';
import '../theme/app_theme.dart';
import '../widgets/content_row.dart';
import '../widgets/hero_banner.dart';
import '../widgets/search_overlay.dart';
import '../widgets/top_nav_bar.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final Set<String> _myListIds = {};

  bool _isScrolled = false;
  bool _showSearch = false;
  int _selectedCategory = 0;
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 40;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openDetail(ContentItem item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailScreen(item: item),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  void _playOrDetail(ContentItem item) {
    if (item.isPlayable) {
      GameRouter.open(context, item);
    } else {
      _openDetail(item);
    }
  }

  void _toggleMyList(ContentItem item) {
    setState(() {
      if (_myListIds.contains(item.id)) {
        _myListIds.remove(item.id);
      } else {
        _myListIds.add(item.id);
      }
    });
    final added = _myListIds.contains(item.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added
              ? '“${item.title}” en Mi lista'
              : '“${item.title}” quitado de Mi lista',
        ),
        backgroundColor: AppTheme.surface,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<ContentItem> get _myListItems =>
      MockData.allContent.where((c) => _myListIds.contains(c.id)).toList();

  List<ContentRow> get _filteredRows {
    switch (_selectedCategory) {
      case 1: // Jugar
        return [
          ContentRow(title: 'Listos para jugar', items: MockData.playable),
          ContentRow(
            title: 'Todos los juegos',
            items: MockData.allContent,
          ),
        ];
      case 2: // Aprender
        return [
          ContentRow(
            title: 'Aprende jugando',
            items: MockData.allContent
                .where((c) => c.category == 'Aprender')
                .toList(),
          ),
        ];
      case 3: // Arte
        return [
          ContentRow(
            title: 'Arte y creatividad',
            items: MockData.allContent
                .where((c) =>
                    c.category == 'Arte' || c.tags.contains('Creatividad'))
                .toList(),
          ),
        ];
      case 4: // Animales
        return [
          ContentRow(
            title: 'Animales y granja',
            items: MockData.allContent
                .where((c) =>
                    c.category == 'Animales' ||
                    c.category == 'Cuidado' ||
                    c.tags.contains('Animales'))
                .toList(),
          ),
        ];
      case 5: // Mi Lista
        return [
          ContentRow(title: 'Mi lista', items: _myListItems),
        ];
      default:
        return MockData.rows;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          if (_bottomNavIndex == 0) _buildBrowse(),
          if (_bottomNavIndex == 1) _buildFavorites(),
          if (_bottomNavIndex == 2) _buildAbout(),
          if (_bottomNavIndex == 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TopNavBar(
                isScrolled: _isScrolled,
                selectedIndex: _selectedCategory,
                categories: MockData.categories,
                onCategorySelected: (i) {
                  setState(() => _selectedCategory = i);
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
                onSearch: () => setState(() => _showSearch = true),
                onProfile: () => _showProfiles(context),
              ),
            ),
          if (_showSearch)
            SearchOverlay(
              onClose: () => setState(() => _showSearch = false),
              onItemSelected: (item) {
                setState(() => _showSearch = false);
                _playOrDetail(item);
              },
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomNavIndex,
        onDestinationSelected: (i) => setState(() => _bottomNavIndex = i),
        backgroundColor: AppTheme.background,
        indicatorColor: Colors.white.withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports_rounded),
            label: 'Juegos',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline_rounded),
            selectedIcon: Icon(Icons.info_rounded),
            label: 'Info',
          ),
        ],
      ),
    );
  }

  Widget _buildBrowse() {
    final rows = _filteredRows;
    final showHero = _selectedCategory == 0;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (showHero)
          SliverToBoxAdapter(
            child: HeroBanner(
              items: MockData.featured,
              onPlay: (item) => GameRouter.open(context, item),
              onInfo: _openDetail,
              onMyList: _toggleMyList,
            ),
          )
        else
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.paddingOf(context).top + 72),
          ),
        if (_selectedCategory == 5 && _myListItems.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyState(
              emoji: '⭐',
              title: 'Tu lista está vacía',
              subtitle:
                  'Guarda juegos con el botón “Mi lista” para encontrarlos aquí.',
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ContentRowWidget(
                  row: rows[index],
                  onItemTap: _playOrDetail,
                );
              },
              childCount: rows.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildFavorites() {
    final items = _myListItems;
    return SafeArea(
      child: items.isEmpty
          ? const _EmptyState(
              emoji: '💛',
              title: 'Sin favoritos aún',
              subtitle: 'Añade juegos a Mi lista desde el inicio.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Mis juegos',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 16),
                ...items.map((item) {
                  return ListTile(
                    onTap: () => _playOrDetail(item),
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    leading: CircleAvatar(
                      backgroundColor: Color(item.gradientColors.first),
                      child: Text(item.emoji),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      item.category,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Colors.white54),
                  );
                }),
              ],
            ),
    );
  }

  Widget _buildAbout() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JUEGA+',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Una app de juegos infantiles. Por ahora puedes jugar a Colorea y Pinta: elige un dibujo y píntalo con los dedos.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tus dibujos van en:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'assets/coloring/\n+ lib/data/coloring_pages.dart',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfiles(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final profiles = [
          ('Luna', '🚀', const [Color(0xFF7C4DFF), Color(0xFF00BCD4)]),
          ('Max', '🦕', const [Color(0xFF66BB6A), Color(0xFFFFEB3B)]),
          ('Sofía', '🎨', const [Color(0xFFE91E63), Color(0xFFFF80AB)]),
        ];

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '¿Quién juega?',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: profiles.map((p) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('¡A jugar, ${p.$1}!'),
                          backgroundColor: AppTheme.cardDark,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: p.$3),
                          ),
                          child: Center(
                            child: Text(p.$2,
                                style: const TextStyle(fontSize: 32)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.$1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
