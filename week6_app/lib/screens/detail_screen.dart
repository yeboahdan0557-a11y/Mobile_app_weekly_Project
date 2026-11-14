import 'package:material_ui/material_ui.dart';

import '../constants.dart';
import '../models/item.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppTitle),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: onEdit),
          IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: onDelete),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Same tag as the home card, so the avatar "flies" across.
                Hero(
                  tag: 'avatar_${item.id}',
                  child: CircleAvatar(
                    radius: 32,
                    child: Text(
                      item.title.isEmpty ? '?' : item.title[0].toUpperCase(),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Chip(label: Text(item.category)),
                const SizedBox(height: 12),
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item.subtitle,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                Text(item.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text('Added: ${_formatDate(item.createdAt)}',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
