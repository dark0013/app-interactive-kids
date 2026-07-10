import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TopNavBar extends StatelessWidget {
  final bool isScrolled;
  final int selectedIndex;
  final List<String> categories;
  final ValueChanged<int> onCategorySelected;
  final VoidCallback onSearch;
  final VoidCallback onProfile;

  const TopNavBar({
    super.key,
    required this.isScrolled,
    required this.selectedIndex,
    required this.categories,
    required this.onCategorySelected,
    required this.onSearch,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final isWide = MediaQuery.sizeOf(context).width > 800;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(
        top: topPadding + 8,
        left: 16,
        right: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isScrolled
              ? [
                  AppTheme.background,
                  AppTheme.background.withValues(alpha: 0.95),
                ]
              : [
                  Colors.black.withValues(alpha: 0.75),
                  Colors.transparent,
                ],
        ),
        color: isScrolled ? AppTheme.background : null,
      ),
      child: Row(
        children: [
          // Logo
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppTheme.netflixRed, Color(0xFFFF6B6B)],
            ).createShader(bounds),
            child: const Text(
              'JUEGA+',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 20),
          if (isWide)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categories.length, (i) {
                    final selected = selectedIndex == i;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextButton(
                        onPressed: () => onCategorySelected(i),
                        style: TextButton.styleFrom(
                          foregroundColor: selected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.7),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          categories[i],
                          style: TextStyle(
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14,
                            decoration: selected
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
          else
            const Spacer(),
          IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Buscar',
          ),
          IconButton(
            onPressed: onProfile,
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF00BCD4)],
                ),
              ),
              child: const Center(
                child: Text('🧒', style: TextStyle(fontSize: 16)),
              ),
            ),
            tooltip: 'Perfil',
          ),
        ],
      ),
    );
  }
}
