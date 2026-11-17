import 'package:flutter/material.dart';

import '../constants.dart';
import '../data/item_repository.dart';
import '../models/item.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../theme/typography_guide.dart';
import 'detail_screen.dart';
import 'item_form_screen.dart';

enum SortMode {
  newest('Newest first'),
  oldest('Oldest first'),
  nameAsc('Name A–Z'),
  nameDesc('Name Z–A');

  final String label;
  const SortMode(this.label);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  List<Item> _allItems = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  SortMode _sortMode = SortMode.newest;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Loads saved items and the saved sort choice. Also used by pull-to-refresh.
  Future<void> _load() async {
    final saved = await _storage.loadItems();
    final sortIdx = await _storage.loadSortIndex();
    if (!mounted) return;
    setState(() {
      _allItems = saved ?? ItemRepository.sample();
      if (sortIdx != null && sortIdx >= 0 && sortIdx < SortMode.values.length) {
        _sortMode = SortMode.values[sortIdx];
      }
      _isLoading = false;
    });
  }

  // Update the screen first, then save to disk.
  Future<void> _updateAndPersist(List<Item> items) async {
    setState(() => _allItems = items);
    await _storage.saveItems(items);
  }

  void _setSortMode(SortMode mode) {
    setState(() => _sortMode = mode);
    _storage.saveSortIndex(mode.index);
  }

  // If the selected category no longer exists, fall back to 'All'.
  String get _activeCategory =>
      _categories.contains(_selectedCategory) ? _selectedCategory : 'All';

  List<Item> get _filteredItems {
    // Copy first, so sorting never reorders the stored list.
    var result = List<Item>.of(_allItems);

    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where((item) =>
              item.title.toLowerCase().contains(q) ||
              item.subtitle.toLowerCase().contains(q) ||
              item.description.toLowerCase().contains(q))
          .toList();
    }

    if (_activeCategory != 'All') {
      result = result.where((item) => item.category == _activeCategory).toList();
    }

    switch (_sortMode) {
      case SortMode.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortMode.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortMode.nameAsc:
        result.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortMode.nameDesc:
        result.sort(
            (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
    }
    return result;
  }

  List<String> get _categories {
    final cats = _allItems.map((i) => i.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  String _initial(Item item) =>
      item.title.isEmpty ? '?' : item.title[0].toUpperCase();

  // ---------- navigation and actions ----------

  Future<void> _openDetail(Item item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          item: item,
          onEdit: () => _openEditForm(item),
          onDelete: () => _deleteItem(item),
        ),
      ),
    );
  }

  Future<void> _openAddForm() async {
    final newItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(builder: (_) => const ItemFormScreen()),
    );
    if (newItem != null) {
      await _updateAndPersist([..._allItems, newItem]);
    }
  }

  Future<void> _openEditForm(Item item) async {
    final updated = await Navigator.push<Item>(
      context,
      MaterialPageRoute(builder: (_) => ItemFormScreen(existing: item)),
    );
    if (updated == null) return;

    // Find by id, not title (titles can be duplicated).
    final i = _allItems.indexWhere((x) => x.id == item.id);
    if (i == -1) return;
    final copy = [..._allItems];
    copy[i] = updated;
    await _updateAndPersist(copy);

    // The open detail screen still holds the old item, so close it.
    if (mounted) Navigator.pop(context);
  }

  Future<bool> _confirmDelete(Item item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Delete "${item.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          // One-off style: the delete button is red on purpose.
          TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(ctx).colorScheme.error),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    // Only a real "true" deletes. Cancel (false) or tapping outside (null) does not.
    return result == true;
  }

  Future<void> _deleteItem(Item item) async {
    if (!await _confirmDelete(item)) return;
    await _updateAndPersist(_allItems.where((x) => x.id != item.id).toList());
    if (mounted) Navigator.pop(context); // close the detail screen
  }

  void _deleteWithUndo(Item item) {
    _updateAndPersist(_allItems.where((x) => x.id != item.id).toList());
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Deleted "${item.title}"'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (!mounted) return;
            if (_allItems.any((x) => x.id == item.id)) return;
            _updateAndPersist([..._allItems, item]);
          },
        ),
      ),
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoading();
    final items = _filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppTitle),
        actions: [
          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort),
            onSelected: _setSortMode,
            itemBuilder: (_) => SortMode.values
                .map((m) => PopupMenuItem(value: m, child: Text(m.label)))
                .toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddForm,
        child: const Icon(Icons.add),
      ),
      // On desktop the content stays at most 1200 px wide and is centred.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildSignatureHeader(),
              _buildSectionHeader(),
              _buildSearchBar(),
              _buildChips(),
              _buildStats(items),
              Expanded(
                child: items.isEmpty ? _buildEmpty() : _buildList(items),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            AppText.body(context, 'Loading items...'),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AppText.display(context, kSignature, color: Colors.white),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppText.headline(context, 'My Playlist'),
      ),
    );
  }

  // No border here: the look comes from inputDecorationTheme.
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: const InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildChips() {
    final cats = _categories;
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cats.length,
        itemBuilder: (_, i) {
          final cat = cats[i];
          final isSelected = cat == _activeCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedCategory = cat),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStats(List<Item> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppText.caption(
            context, '${items.length} of ${_allItems.length} items'),
      ),
    );
  }

  // Three breakpoints: phone list, tablet 2 columns, desktop 3 columns.
  Widget _buildList(List<Item> items) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      Widget content;
      if (width >= Breakpoints.desktop) {
        content = GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 96),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 104,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => _buildCard(items[i], i),
        );
      } else if (width >= Breakpoints.tablet) {
        content = GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 104,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => _buildCard(items[i], i),
        );
      } else {
        content = ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: items.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: _buildCard(items[i], i),
          ),
        );
      }
      return RefreshIndicator(onRefresh: _load, child: content);
    });
  }

  // Each card fades in and slides up. Later cards take a little longer, so
  // they appear one after another instead of all at once.
  Widget _buildCard(Item item, int index) {
    final scheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      key: ValueKey('card_${item.id}'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + 80 * (index < 8 ? index : 8)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: scheme.error,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (_) => _confirmDelete(item),
        onDismissed: (_) => _deleteWithUndo(item),
        // No elevation or margin here: the Card reads them from the theme.
        child: Card(
          child: ListTile(
            onTap: () => _openDetail(item),
            leading: Hero(
              tag: 'avatar_${item.id}',
              child: CircleAvatar(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                child: Text(_initial(item)),
              ),
            ),
            title: AppText.title(context, item.title,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: AppText.subtitle(
              context,
              '${item.subtitle} · ${item.category}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: scheme.onSurfaceVariant,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  // Four different messages: nothing / search / filter / search + filter.
  Widget _buildEmpty() {
    final query = _searchQuery.trim();
    final searching = query.isNotEmpty;
    final filtering = _activeCategory != 'All';

    final String title;
    final String subtitle;
    final IconData icon;

    if (searching && filtering) {
      title = 'No results in $_activeCategory';
      subtitle = 'Try a different search or clear the filter';
      icon = Icons.filter_alt_off;
    } else if (searching) {
      title = 'No results for "$query"';
      subtitle = 'Try a different word';
      icon = Icons.search_off;
    } else if (filtering) {
      title = 'No items in $_activeCategory';
      subtitle = 'Tap "All" to see everything';
      icon = Icons.folder_off;
    } else {
      title = 'No items yet';
      subtitle = 'Tap + to add your first item';
      icon = Icons.inbox_outlined;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            AppText.title(context, title, align: TextAlign.center),
            const SizedBox(height: 8),
            AppText.caption(context, subtitle, align: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
