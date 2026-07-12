/// Identificador del juego que abre la app al tocar un ítem del menú.
enum GameId {
  coloring,
  animals,
  comingSoon,
}

class ContentItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final GameId gameId;
  final int ageRating;
  final double rating;
  final List<String> tags;
  final List<int> gradientColors;
  final String emoji;
  final bool isFeatured;
  final bool isNew;
  final String playLabel;

  const ContentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.gameId,
    required this.ageRating,
    required this.rating,
    required this.tags,
    required this.gradientColors,
    required this.emoji,
    this.isFeatured = false,
    this.isNew = false,
    this.playLabel = 'Jugar',
  });

  bool get isPlayable => gameId != GameId.comingSoon;
}

class ContentRow {
  final String title;
  final List<ContentItem> items;

  const ContentRow({
    required this.title,
    required this.items,
  });
}
