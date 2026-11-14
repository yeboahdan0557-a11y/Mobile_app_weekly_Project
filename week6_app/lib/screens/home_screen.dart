import 'package:material_ui/material_ui.dart';

import '../constants.dart';
import '../data/item_repository.dart';
import '../models/item.dart';
import '../services/storage_services.dart';
import 'detail_screen.dart';
import 'items_screens.dart';

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

  // Loads saved items + sort choice. Also used by pull-to-refresh.
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

  // Updates the screen AND saves to disk. setState runs first (synchronously),
  // so the UI changes immediately, then the save finishes in the background.
  Future<void> _updateAndPersist(List<Item> items) async {
    setState(() => _allItems = items);
    await _storage.saveItems(items);
  }

  void _setSortMode(SortMode mode) {
    setState(() => _sortMode = mode);
    _storage.saveSortIndex(mode.index);
  }

  // If the selected category disappears (e.g. its last item was deleted),
  // fall back to 'All' instead of showing an empty list with nothing selected.
  String get _activeCategory =>
      _categories.contains(_selectedCategory) ? _selectedCategory : 'All';

  List<Item> get _filteredItems {
    // BUG FIX: copy the list. Sorting _allItems itself would reorder the real
    // data every time build() runs.
    var result = List<Item>.of(_allItems);

    // BUG FIX: compare in lower case so search is case-insensitive.
    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where(
            (item) =>
                item.title.toLowerCase().contains(q) ||
                item.subtitle.toLowerCase().contains(q) ||
                item.description.toLowerCase().contains(q),
          )
          .toList();
    }

    if (_activeCategory != 'All') {
      result = result
          .where((item) => item.category == _activeCategory)
          .toList();
    }

    switch (_sortMode) {
      case SortMode.newest:
        // BUG FIX: newest first = bigger date first, so compare b to a.
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortMode.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortMode.nameAsc:
        // BUG FIX: lower-case both titles so "apple" and "Banana" sort fairly.
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SortMode.nameDesc:
        result.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
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
    if (updated == null) return; // user backed out, change nothing

    // BUG FIX: find the item by id, not title (titles can be duplicated).
    final i = _allItems.indexWhere((x) => x.id == item.id);
    if (i == -1) return;
    final copy = [..._allItems];
    copy[i] = updated;
    await _updateAndPersist(copy);

    // BUG FIX: the open detail screen still holds the OLD item, so close it.
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    // BUG FIX: only a real "true" counts. Cancel (false) or tapping outside
    // (null) must NOT delete. The old code checked `!= null`.
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
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildChips(),
          _buildStats(items),
          Expanded(child: items.isEmpty ? _buildEmpty() : _buildList(items)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, kAccentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Text(
        kSignature,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(cat),
              // BUG FIX: was `selected: true` for every chip.
              selected: cat == _activeCategory,
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
      // BUG FIX: show "filtered of total", not just the total.
      child: Text(
        '${items.length} of ${_allItems.length} items',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildList(List<Item> items) {
    return LayoutBuilder(
      builder: (_, constraints) {
        Widget content;
        if (constraints.maxWidth >= 600) {
          content = GridView.builder(
            // Needed so pull-to-refresh works even when the list is short.
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            // BUG FIX: childAspectRatio 5.0 made cells too short and cut the
            // content off. A fixed cell height (mainAxisExtent) always fits.
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 96,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => _buildCard(items[i], inGrid: true),
          );
        } else {
          content = ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: items.length,
            itemBuilder: (_, i) => _buildCard(items[i]),
          );
        }
        return RefreshIndicator(onRefresh: _load, child: content);
      },
    );
  }

  Widget _buildCard(Item item, {bool inGrid = false}) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(item),
      onDismissed: (_) => _deleteWithUndo(item),
      child: Card(
        // In the grid the grid already adds spacing, so no extra margin.
        margin: inGrid
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          onTap: () => _openDetail(item),
          leading: Hero(
            tag: 'avatar_${item.id}',
            child: CircleAvatar(child: Text(_initial(item))),
          ),
          title: Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${item.subtitle} · ${item.category}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    final query = _searchQuery.trim();
    final searching = query.isNotEmpty;
    final filtering = _activeCategory != 'All';

    // BUG FIX: different messages for search, filter, and nothing at all.
    final String message;
    final IconData icon;
    if (searching) {
      message = filtering
          ? 'No results for "$query" in $_activeCategory'
          : 'No results for "$query"';
      icon = Icons.search_off;
    } else if (filtering) {
      message = 'No items in the "$_activeCategory" category';
      icon = Icons.filter_list_off;
    } else {
      message = 'No items yet. Tap + to add one.';
      icon = Icons.inbox;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
