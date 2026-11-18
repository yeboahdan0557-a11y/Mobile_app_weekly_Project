class TicketSale {
  TicketSale({
    required this.buyerName,
    required this.age,
    required this.category,
    required this.quantity,
    required this.isMember,
  }) {
    if (age < 0 || age > 120) {
      throw ArgumentError.value(age, 'age', 'Must be between 0 and 120');
    }
    if (!const ['Child', 'Teen', 'Adult'].contains(category)) {
      throw ArgumentError.value(
        category,
        'category',
        'Unsupported ticket category',
      );
    }
    if (quantity <= 0) {
      throw ArgumentError.value(
        quantity,
        'quantity',
        'Must be greater than zero',
      );
    }
  }

  final String buyerName;
  final int age;
  final String category;
  final int quantity;
  final bool isMember;

  double calculateTotalPrice() {
    final price = switch (category) {
      'Child' => 10.0,
      'Teen' => 15.0,
      'Adult' => 25.0,
      _ => 0.0,
    };
    final subtotal = price * quantity;
    var discount = 0.0;
    if (isMember) discount += 0.10;
    if (quantity >= 5) discount += 0.05;
    return subtotal * (1 - discount);
  }

  static int parseQuantity(String value) {
    final quantity = int.tryParse(value.trim());
    if (quantity == null || quantity <= 0) {
      throw FormatException('Quantity must be a positive integer', value);
    }
    return quantity;
  }
}

class SalesSummaryReport {
  SalesSummaryReport(List<TicketSale> sales)
    : _sales = List.unmodifiable(sales);

  final List<TicketSale> _sales;

  double getTotalRevenue() =>
      _sales.fold(0.0, (total, sale) => total + sale.calculateTotalPrice());

  Map<String, int> getTicketsSoldPerCategory() {
    final totals = <String, int>{'Child': 0, 'Teen': 0, 'Adult': 0};
    for (final sale in _sales) {
      totals[sale.category] = (totals[sale.category] ?? 0) + sale.quantity;
    }
    return totals;
  }

  List<String> getUniqueBuyers() {
    final buyers = <String, String>{};
    for (final sale in _sales) {
      final name = sale.buyerName.trim();
      buyers.putIfAbsent(name.toLowerCase(), () => name);
    }
    return buyers.values.toList();
  }

  List<TicketSale> getBigSpenders() =>
      _sales.where((sale) => sale.calculateTotalPrice() >= 100.0).toList();
}
