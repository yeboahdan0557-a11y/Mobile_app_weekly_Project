// ignore_for_file: avoid_print
// INFT 425 - Week 3: Loops & Utility Functions
// Student: Yeboah Daniel

void main() {
  print('=== LOOPS & COLLECTIONS ===');
  List<String> favoriteFoods = [
    'Fufu',
    'Jollof Rice',
    'Waakye',
    'Banku',
    'Red Red',
  ];

  for (String food in favoriteFoods) {
    print('- $food');
  }

  print('\n=== UTILITY FUNCTIONS ===');
  print('Greet: ${greet("Yeboah")}');
  print('Is 7 Even? ${isEven(7)}');
  print('Average of [80, 90, 85]: ${calculateAverage([80, 90, 85])}');
  print('Max of (12, 45, 27): ${maxOfThree(12, 45, 27)}');
  print('Reversed "Flutter": ${reverseString("Flutter")}');
  print('Is "radar" Palindrome? ${isPalindrome("radar")}');
  print('Factorial of 5: ${factorial(5)}');
}

/// Returns a greeting string
String greet(String name) => "Hello, $name!";

/// Returns true if number is even
bool isEven(int n) => n % 2 == 0;

/// Returns the calculated average of a list of numbers
double calculateAverage(List<int> numbers) {
  if (numbers.isEmpty) return 0.0;
  int sum = numbers.reduce((a, b) => a + b);
  return sum / numbers.length;
}

/// Returns the largest of three numbers
int maxOfThree(int a, int b, int c) {
  return [a, b, c].reduce((x, y) => x > y ? x : y);
}

/// Returns the reversed string
String reverseString(String s) => s.split('').reversed.join('');

/// Custom function: checks if a string is a palindrome
bool isPalindrome(String s) {
  String cleaned = s.toLowerCase().replaceAll(' ', '');
  return cleaned == cleaned.split('').reversed.join('');
}

/// Custom function: computes the factorial of n ($n!$)
int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}
