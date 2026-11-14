import '../models/item.dart';

class ItemRepository {
  // TODO: REPLACE these 5 items with 5 real items from YOUR assigned theme.
  // Placeholder data costs -15 points, and your data must differ from every
  // other student's. Categories must match the list in item_form_screen.dart.
  static List<Item> sample() => [
        Item(
          id: '1',
          title: 'REPLACE ME 1',
          subtitle: 'Subtitle 1',
          description: 'Description for the first item goes here.',
          category: 'General',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Item(
          id: '2',
          title: 'REPLACE ME 2',
          subtitle: 'Subtitle 2',
          description: 'Description for the second item goes here.',
          category: 'General',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Item(
          id: '3',
          title: 'REPLACE ME 3',
          subtitle: 'Subtitle 3',
          description: 'Description for the third item goes here.',
          category: 'Featured',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Item(
          id: '4',
          title: 'REPLACE ME 4',
          subtitle: 'Subtitle 4',
          description: 'Description for the fourth item goes here.',
          category: 'Featured',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Item(
          id: '5',
          title: 'REPLACE ME 5',
          subtitle: 'Subtitle 5',
          description: 'Description for the fifth item goes here.',
          category: 'Archive',
          createdAt: DateTime.now(),
        ),
      ];
}
