import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/content_item.dart';
import '../theme/app_theme.dart';
import 'content_card.dart';

class SearchOverlay extends StatefulWidget {
  final void Function(ContentItem item) onItemSelected;
  final VoidCallback onClose;

  const SearchOverlay({
    super.key,
    required this.onItemSelected,
    required this.onClose,
  });

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final _controller = TextEditingController();
  List<ContentItem> _results = MockData.allContent;

  void _onQuery(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _results = MockData.allContent;
      } else {
        _results = MockData.allContent.where((item) {
          return item.title.toLowerCase().contains(q) ||
              item.category.toLowerCase().contains(q) ||
              item.tags.any((t) => t.toLowerCase().contains(q)) ||
              item.description.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.background.withValues(alpha: 0.97),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: _onQuery,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Títulos, géneros, temas...',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Colors.white70),
                        filled: true,
                        fillColor: AppTheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onClose,
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _controller.text.isEmpty
                      ? 'Explorar todo'
                      : '${_results.length} resultados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 56,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No encontramos nada para “${_controller.text}”',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 160,
                        mainAxisExtent: 210,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        return ContentCard(
                          item: item,
                          onTap: () => widget.onItemSelected(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
