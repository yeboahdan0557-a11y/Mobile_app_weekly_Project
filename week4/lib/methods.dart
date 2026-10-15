void main() {
  // Part 9 & 10: Higher-Order Methods (.map, .where, .reduce, .fold)
  List<int> numbers = [1, 2, 3, 4, 5];
  
  var doubled = numbers.map((n) => n * 2).toList();
  var evens = numbers.where((n) => n.isEven).toList();
  var sum = numbers.reduce((a, b) => a + b);
  
  // Safe alternative for empty lists (.fold)
  List<int> emptyList = [];
  var safeSum = emptyList.fold(0, (a, b) => a + b);

  print('Doubled: $doubled');
  print('Evens: $evens');
  print('Sum: $sum');
  print('Safe Fold Sum (empty list): $safeSum');
}