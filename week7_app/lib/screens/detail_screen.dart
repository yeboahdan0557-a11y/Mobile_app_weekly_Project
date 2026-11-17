import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/item.dart';
import '../theme/typography_guide.dart';

class DetailScreen extends StatelessWidget {
  final Item item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DetailScreen({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppTitle),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit), tooltip: 'Edit', onPressed: onEdit),
          IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: onDelete),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              // Keeps the card readable on tablets and desktops.
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'avatar_${item.id}',
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: scheme.primary,
                              foregroundColor: scheme.onPrimary,
                              child: Text(
                                item.title.isEmpty
                                    ? '?'
                                    : item.title[0].toUpperCase(),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Chip(label: Text(item.category)),
                          const SizedBox(height: 12),
                          AppText.headline(context, item.title),
                          const SizedBox(height: 4),
                          AppText.subtitle(context, item.subtitle,
                              color: scheme.onSurfaceVariant),
                          const SizedBox(height: 16),
                          AppText.body(context, item.description),
                          const SizedBox(height: 16),
                          AppText.caption(
                              context, 'Added: ${_formatDate(item.createdAt)}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // AI-suggested change: a clear action row at the bottom of the screen.
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        // One-off style: delete is red on purpose.
                        child: OutlinedButton.icon(
                          onPressed: onDelete,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: scheme.error,
                            side: BorderSide(color: scheme.error),
                          ),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
