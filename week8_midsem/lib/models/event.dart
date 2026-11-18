class CampusEvent {
  final String id;
  final String name;
  final String venue;
  final String date;
  final double price;
  final int availableSeats;
  final int totalCapacity;
  final bool isSoldOut;
  final String category;

  CampusEvent({
    required this.id,
    required this.name,
    required this.venue,
    required this.date,
    required this.price,
    required this.availableSeats,
    required this.totalCapacity,
    required this.isSoldOut,
    required this.category,
  });

  static List<CampusEvent> sampleEvents = [
    CampusEvent(
      id: '1',
      name: 'AI & Robotics Tech Fest 2026',
      venue: 'Bulley Room 1, VVU',
      date: 'Nov 25, 2026 • 10:00 AM',
      price: 25.00,
      availableSeats: 0,
      totalCapacity: 150,
      isSoldOut: true,
      category: 'Technology',
    ),
    CampusEvent(
      id: '2',
      name: 'Flutter Mobile Dev Bootcamp',
      venue: 'Computer Lab B',
      date: 'Nov 28, 2026 • 2:00 PM',
      price: 15.00,
      availableSeats: 42,
      totalCapacity: 100,
      isSoldOut: false,
      category: 'Workshop',
    ),
  ];
}