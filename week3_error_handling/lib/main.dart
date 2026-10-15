// ignore_for_file: avoid_print
// INFT 425 - Week 3: Error Handling & Custom Exceptions
// Student: Yeboah Daniel | Valley View University

/// Custom exception class for handling out-of-range assessment scores
class OutOfRangeException implements Exception {
  final String message;
  OutOfRangeException(this.message);

  @override
  String toString() => 'OutOfRangeException: $message';
}

/// Function that divides two numbers and handles division by zero
double divide(int a, int b) {
  if (b == 0) {
    throw UnsupportedError('Cannot divide by zero.');
  }
  return a / b;
}

/// Function that validates assessment scores and throws a custom exception
void validateAssessmentScore(double score) {
  if (score < 0 || score > 100) {
    throw OutOfRangeException(
      'Score must be between 0 and 100. Received: $score',
    );
  }
}

void main() {
  print('=== 1. TRY / CATCH / FINALLY: DIVISION BY ZERO ===');
  try {
    print('Attempting 10 / 2...');
    print('Result: ${divide(10, 2)}');

    print('Attempting 10 / 0...');
    print('Result: ${divide(10, 0)}');
  } catch (e) {
    print('Caught Runtime Exception: $e');
  } finally {
    print('Calculation complete (Finally block executed).\n');
  }

  print('=== 2. CUSTOM EXCEPTION: SCORE VALIDATION ===');
  try {
    print('Validating score 85...');
    validateAssessmentScore(85);
    print('Score 85 is valid.\n');

    print('Validating score 120 (Invalid)...');
    validateAssessmentScore(120);
  } on OutOfRangeException catch (e) {
    print('Caught Custom Exception: $e');
  } finally {
    print('Validation process finished.');
  }
}
