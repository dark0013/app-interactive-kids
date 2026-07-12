import 'package:flutter/material.dart';
import '../games/animals/animals_game_screen.dart';
import '../games/coloring/coloring_home_screen.dart';
import '../models/content_item.dart';
import '../theme/app_theme.dart';

/// Abre el juego correspondiente a un ítem del menú.
class GameRouter {
  static void open(BuildContext context, ContentItem item) {
    switch (item.gameId) {
      case GameId.coloring:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ColoringHomeScreen(),
          ),
        );
      case GameId.animals:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AnimalsGameScreen(),
          ),
        );
      case GameId.comingSoon:
        _showComingSoon(context, item);
    }
  }

  static void _showComingSoon(BuildContext context, ContentItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          content: const Text(
            '¡Este juego estará listo muy pronto!\n\nPor ahora puedes jugar a Colorea y Pinta o Sonidos de Animales.',
            style: TextStyle(color: AppTheme.textSecondary, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AnimalsGameScreen(),
                  ),
                );
              },
              child: const Text('Sonidos de animales'),
            ),
          ],
        );
      },
    );
  }
}
