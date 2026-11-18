import 'package:test/test.dart';

import '../lib/ticket_system.dart';

void main() {
  group('TicketSale and SalesSummaryReport Tests', () {
    test('1. Calculates adult ticket price with member discount correctly', () {
      final sale = TicketSale(
        buyerName: 'Yaw Mensah',
        age: 25,
        category: 'Adult',
        quantity: 2,
        isMember: true,
      );
      expect(sale.calculateTotalPrice(), equals(45.0));
    });

    test('2. Applies both member and volume discounts (>=5 tickets)', () {
      final sale = TicketSale(
        buyerName: 'Abena Kusi',
        age: 16,
        category: 'Teen',
        quantity: 5,
        isMember: true,
      );
      expect(sale.calculateTotalPrice(), equals(63.75));
    });
    test('3. Rejects invalid ages with ArgumentError', () {
      expect(
        () => TicketSale(
          buyerName: 'Test',
          age: 150,
          category: 'Adult',
          quantity: 1,
          isMember: false,
        ),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => TicketSale(
          buyerName: 'Test',
          age: -2,
          category: 'Child',
          quantity: 1,
          isMember: false,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('4. Rejects unsupported ticket categories', () {
      expect(
        () => TicketSale(
          buyerName: 'Test',
          age: 20,
          category: 'General',
          quantity: 1,
          isMember: false,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('5. Parses valid quantity string correctly', () {
      expect(TicketSale.parseQuantity('  5  '), equals(5));
    });

    test('6. Throws FormatException on invalid quantity input text', () {
      expect(
        () => TicketSale.parseQuantity('invalid'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => TicketSale.parseQuantity('0'),
        throwsA(isA<FormatException>()),
      );
    });

    test('7. Treats unique buyers case-insensitively and trims whitespace', () {
      final salesList = [
        TicketSale(
          buyerName: 'Kwame Nkrumah',
          age: 30,
          category: 'Adult',
          quantity: 1,
          isMember: false,
        ),
        TicketSale(
          buyerName: 'kwame nkrumah ',
          age: 30,
          category: 'Adult',
          quantity: 1,
          isMember: false,
        ),
        TicketSale(
          buyerName: 'Yeboah Daniel',
          age: 22,
          category: 'Adult',
          quantity: 1,
          isMember: false,
        ),
      ];
      final report = SalesSummaryReport(salesList);
      expect(report.getUniqueBuyers().length, equals(2));
      expect(report.getUniqueBuyers(), contains('Kwame Nkrumah'));
      expect(report.getUniqueBuyers(), contains('Yeboah Daniel'));
    });

    test('8. Handles empty collections in sales report gracefully', () {
      final report = SalesSummaryReport([]);
      expect(report.getTotalRevenue(), equals(0.0));
      expect(report.getTicketsSoldPerCategory()['Adult'], equals(0));
      expect(report.getUniqueBuyers(), isEmpty);
      expect(report.getBigSpenders(), isEmpty);
    });
  });
}
