import 'package:material_ui/material_ui.dart';

import '../constants.dart';
import '../models/item.dart';

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

  // TODO: change to the 3 categories of YOUR theme (must match sample data).
  final List<String> _categories = ['General', 'Featured', 'Archive'];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
    _subtitleCtrl =
        TextEditingController(text: widget.existing?.subtitle ?? '');
    _descriptionCtrl =
        TextEditingController(text: widget.existing?.description ?? '');
    // Safety: if an old saved item has a category that is no longer in the
    // list, the dropdown would crash, so fall back to the first category.
    final existingCategory = widget.existing?.category;
    _category = (existingCategory != null &&
            _categories.contains(existingCategory))
        ? existingCategory
        : _categories.first;
  }

  // BUG FIX: controllers must be disposed or they leak memory.
  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      // After the first failed submit, re-validate on every keystroke.
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
      // Save trimmed text so "  Hello  " is stored as "Hello".
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
      body: Form(
        key: _formKey,
        autovalidateMode: _submitted
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(editing ? 'Edit Item' : 'Add Item',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              // BUG FIX: trim first, so spaces-only counts as empty.
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
              decoration: const InputDecoration(
                labelText: 'Subtitle',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'Subtitle is required';
                if (t.length > 60) return 'At most 60 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
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
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
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
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(editing ? 'Save Changes' : 'Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
