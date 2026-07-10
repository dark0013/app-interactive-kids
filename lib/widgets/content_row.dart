import 'package:flutter/material.dart';
import '../models/content_item.dart';
import 'content_card.dart';

class ContentRowWidget extends StatelessWidget {
  final ContentRow row;
  final void Function(ContentItem item) onItemTap;

  const ContentRowWidget({
    super.key,
    required this.row,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (row.items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Text(
                row.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.5),
                size: 22,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: row.items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = row.items[index];
              return ContentCard(
                item: item,
                onTap: () => onItemTap(item),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
