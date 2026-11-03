// ===== Week 5 – Part 6: Abstract classes and interfaces =====
import 'dart:math';

abstract class Shape {
  double area();       // abstract: no body
  double perimeter();  // abstract: no body

  String get unit => 'cm²';   // concrete getter

  // Concrete method. Classes that EXTEND Shape inherit it.
  // Classes that IMPLEMENT Shape do not inherit it.
  String describe() {
    final text = 'I am a $runtimeType';
    print(text);
    return text;
  }
}

// IMPLEMENTS = "follow this contract". Circle gets NO code from Shape,
// so it must override every member: area, perimeter, unit and describe.
class Circle implements Shape {
  final double radius;
  Circle(this.radius);

  @override
  double area() => pi * radius * radius;
  @override
  double perimeter() => 2 * pi * radius;
  @override
  String get unit => 'cm²';
  @override
  String describe() {
    final text = 'I am a $runtimeType';
    print(text);
    return text;
  }
}

class Rectangle implements Shape {
  final double width;
  final double height;
  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
  @override
  double perimeter() => 2 * (width + height);
  @override
  String get unit => 'cm²';
  @override
  String describe() {
    final text = 'I am a $runtimeType';
    print(text);
    return text;
  }
}

class Triangle implements Shape {
  final double base;
  final double height;
  final double sideA;
  final double sideB;
  Triangle(this.base, this.height, this.sideA, this.sideB);

  @override
  double area() => 0.5 * base * height;
  @override
  double perimeter() => base + sideA + sideB;
  @override
  String get unit => 'cm²';
  @override
  String describe() {
    final text = 'I am a $runtimeType';
    print(text);
    return text;
  }
}

// Square EXTENDS Rectangle, so it inherits area(), perimeter() and describe().
// It only passes 'side' as both width and height.
class Square extends Rectangle {
  Square(double side) : super(side, side);
}

// Cube EXTENDS Shape: inherits describe() and unit, implements the abstract methods.
class Cube extends Shape {
  final double side;
  Cube(this.side);

  @override
  double area() => 6 * side * side;       // surface area
  @override
  double perimeter() => 12 * side;        // total edge length
  double volume() => side * side * side;  // Cube-only method
}

void main() {
  final List<Shape> shapes = [
    Circle(5),
    Rectangle(4, 6),
    Triangle(6, 4, 5, 5),
    Square(3),
    Cube(2),
  ];

  for (final s in shapes) {
    s.describe();
    print('Area: ${s.area().toStringAsFixed(2)} ${s.unit}');
    print('Perimeter: ${s.perimeter().toStringAsFixed(2)}');
    print('---');
  }

  print('Cube volume: ${Cube(2).volume()}');
}