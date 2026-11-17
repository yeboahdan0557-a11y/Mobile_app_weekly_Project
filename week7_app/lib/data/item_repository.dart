import '../models/item.dart';

// Theme: Music Playlist (Highlife / Hip-hop / Gospel)
class ItemRepository {
  static List<Item> sample() => [
        Item(
          id: '1',
          title: 'Aben Wo Ha',
          subtitle: 'Daddy Lumba',
          description:
              'A well-loved Daddy Lumba highlife song that I keep on repeat on long trotro rides.',
          category: 'Highlife',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        Item(
          id: '2',
          title: 'Theresa',
          subtitle: 'Daddy Lumba',
          description:
              'A smooth highlife track with a gentle guitar line, perfect for a calm evening study session.',
          category: 'Highlife',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Item(
          id: '3',
          title: 'Adonai',
          subtitle: 'Sarkodie ft. Castro',
          description:
              'A hiplife anthem with strong verses and a big hook that gets the whole room singing.',
          category: 'Hip-hop',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Item(
          id: '4',
          title: 'Putuu',
          subtitle: 'Stonebwoy',
          description:
              'An energetic Stonebwoy track that I use as my workout and coding focus song.',
          category: 'Hip-hop',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Item(
          id: '5',
          title: 'Bo Noo Ni',
          subtitle: 'Joe Mettle',
          description:
              'A worship song by Joe Mettle that I play on Sunday mornings before church.',
          category: 'Gospel',
          createdAt: DateTime.now(),
        ),
      ];
}
