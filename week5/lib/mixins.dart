// ===== Week 5 – Part 10: Mixins =====
// A mixin is a bundle of fields and methods that ANY class can reuse with 'with',
// without inheriting from it. Use mixins to share behaviour between classes
// that are NOT in the same family tree (a Duck and an Eagle both fly, but a
// Fish does not). Dart only allows one 'extends', but many mixins.

mixin Flyable {
  int wingspan = 0; // mixins can hold state too
  bool get canFly => true;
  void fly() => print('Flying...');
  void land() => print('Landing...');
}

mixin Swimmable {
  void swim() => print('Swimming...');
  void dive() => print('Diving...');
}

mixin Walkable {
  void walk() => print('Walking...');
}

class Animal {
  String name;
  Animal(this.name);
  void eat() => print('$name is eating');
}

class Duck extends Animal with Flyable, Swimmable, Walkable {
  Duck(super.name);
}

class Fish extends Animal with Swimmable {
  Fish(super.name);
}

class Eagle extends Animal with Flyable {
  Eagle(super.name);
}

class Penguin extends Animal with Swimmable, Walkable {
  Penguin(super.name);
}

void main() {
  final duck = Duck('Donald');
  final fish = Fish('Nemo');
  final eagle = Eagle('Sky');
  final penguin = Penguin('Pingu');

  for (final a in [duck, fish, eagle, penguin]) {
    a.eat();
  }

  duck.fly();
  eagle.fly();
  eagle.wingspan = 220;
  print('Eagle wingspan: ${eagle.wingspan} cm, can fly: ${eagle.canFly}');

  duck.swim();
  fish.swim();
  penguin.swim();

  duck.walk();
  penguin.walk();
}

extension on Object {
  void eat() {}
}