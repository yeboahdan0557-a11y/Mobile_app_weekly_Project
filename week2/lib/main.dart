// ignore_for_file: avoid_print
// INFT 425 - Week 2: Dart Fundamentals, Experiments & Bus Fare Calculator
// Student: Yeboah Daniel | Valley View University

void main() {
  print('=== 1. FIRST DART PROGRAM & VARIABLES ===');
  String studentName = 'Yeboah Daniel';
  int courseCode = 425;
  double targetGpa = 2.6;
  bool isEnrolled = true;             

  // Prints four distinct lines
  print('1. Student Name: $studentName');
  print('2. Course Code: INFT $courseCode');
  print('3. Target GPA: $targetGpa');
  print('4. Enrollment Active: $isEnrolled\n');

  print('=== 2. STRING INTERPOLATION EXPERIMENT (\$ vs \${}) ===');
  // $ for simple variable lookup vs ${} for expressions/operations
  print('Simple interpolation (\$): $studentName');
  print(
    'Expression interpolation (\${}): Upper Case -> ${studentName.toUpperCase()}',
  );
  print(
    'Expression calculation (\${}): Next Year GPA Target -> ${targetGpa + 0.1}\n',
  );

  print('=== 3. OPERATORS & HAND CALCULATIONS ===');
  // Hand Calculation Test:
  // Score 1 = 80, Score 2 = 90, Average = (80 + 90) / 2 = 85.0
  double score1 = 80.0;
  double score2 = 90.0;
  double calculatedAverage = (score1 + score2) / 2;
  print('Hand Calculation Verified: (80 + 90) / 2 = $calculatedAverage\n');

  print('=== 4. BUS FARE CALCULATOR (Part 13) ===');
  double distanceInKm = 12.5;
  double totalFare = calculateBusFare(distanceInKm, isStudent: true);
  print('Distance: $distanceInKm km');
  print('Calculated Bus Fare: GH₵ ${totalFare.toStringAsFixed(2)}\n');
}

/// Bus Fare Calculator Function
/// Pricing Tiers: Base fare GH₵ 5.00 + GH₵ 1.50/km
/// Special Rule: 20% discount for registered students
double calculateBusFare(double distanceKm, {bool isStudent = false}) {
  double baseFare = 5.0;
  double ratePerKm = 1.5;
  double total = baseFare + (distanceKm * ratePerKm);

  if (isStudent) {
    total *= 0.80; // 20% discount applied
  }

  return total;
}
