import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/item.dart';
import '../theme/typography_guide.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? existing;

  const ItemFormScreen({super.key, this.existing});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _subtitleCtrl;
  late final TextEditingController _descriptionCtrl;
  late String _category;
  bool _submitted = false;

  // Categories for my theme (Music Playlist). They match the sample data.
  final List<String> _categories = ['Highlife', 'Hip-hop', 'Gospel'];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
    _subtitleCtrl =
        TextEditingController(text: widget.existing?.subtitle ?? '');
    _descriptionCtrl =
        TextEditingController(text: widget.existing?.description ?? '');
    final existingCategory = widget.existing?.category;
    _category =
        (existingCategory != null && _categories.contains(existingCategory))
            ? existingCategory
            : _categories.first;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _submitted = true);
      return;
    }
    final result = (widget.existing ??
            Item(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: '',
              subtitle: '',
              description: '',
              category: _categories.first,
              createdAt: DateTime.now(),
            ))
        .copyWith(
      title: _titleCtrl.text.trim(),
      subtitle: _subtitleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      category: _category,
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: const Text(kAppTitle)),
      // Fields have no border: the look comes from inputDecorationTheme.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppText.headline(context, editing ? 'Edit Song' : 'Add Song'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return 'Title is required';
                    if (t.length < 3) return 'At least 3 characters';
                    if (t.length > 50) return 'At most 50 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subtitleCtrl,
                  decoration: const InputDecoration(labelText: 'Artist'),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return 'Artist is required';
                    if (t.length > 60) return 'At most 60 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _category = v);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 5,
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return 'Description is required';
                    if (t.length < 10) return 'At least 10 characters';
                    if (t.length > 500) return 'At most 500 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // No style here: the button reads the elevatedButtonTheme.
                ElevatedButton(
                  onPressed: _save,
                  child: Text(editing ? 'Save Changes' : 'Add Song'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
