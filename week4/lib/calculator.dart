import 'package:flutter_test/flutter_test.dart';

int add(int a, int b) => a + b;
int subtract(int a, int b) => a - b;
int multiply(int a, int b) => a * b;
double divide(int a, int b) {
  if (b == 0) throw ArgumentError('Cannot divide by zero');
  return a / b;
}

void main() {
  group('Calculator Tests', () {
    test('Addition works', () {
      expect(add(2, 3), equals(5));
    });

    test('Subtraction works', () {
      expect(subtract(5, 2), equals(3));
    });

    test('Multiplication works', () {
      expect(multiply(3, 4), equals(12));
    });

    test('Division by zero throws error', () {
      expect(() => divide(10, 0), throwsArgumentError);
    });
  });
}