// ignore_for_file: avoid_print
// INFT 425 - Week 3: Control Flow & Switch Expressions
// Student: Yeboah Daniel | Valley View University

void main() {
  int score = 82;

  print('=== IF/ELSE IF/ELSE EVALUATION ===');
  String gradeIf = getGradeIf(score);
  print('Score: $score, Grade: $gradeIf');

  print('\n=== DART 3 SWITCH EXPRESSION EVALUATION ===');
  String gradeSwitch = getGradeSwitch(score);
  print('Score: $score, Grade: $gradeSwitch');

  print('\n=== BOUNDARY & ERROR HANDLING TEST ===');
  checkScoreBoundary(-5);
  checkScoreBoundary(105);
}

// If/Else allows evaluating conditions with custom grade boundaries:
// 85+ = A, 75-84 = B, 65-74 = C, 55-64 = D, below 55 = F
String getGradeIf(int score) {
  if (score >= 85) {
    return 'A';
  } else if (score >= 75) {
    return 'B';
  } else if (score >= 65) {
    return 'C';
  } else if (score >= 55) {
    return 'D';
  } else if (score >= 0) {
    return 'F';
  } else {
    return 'Invalid Score';
  }
}

// Dart 3 Switch expression performs pattern matching on values concisely
String getGradeSwitch(int score) {
  return switch (score) {
    >= 85 && <= 100 => 'A',
    >= 75 && < 85 => 'B',
    >= 65 && < 75 => 'C',
    >= 55 && < 65 => 'D',
    >= 0 && < 55 => 'F',
    _ => 'Invalid Score',
  };
}

void checkScoreBoundary(int score) {
  if (score < 0 || score > 100) {
    print('Error: Score $score is out of valid range (0-100).');
  } else {
    print('Score $score is valid.');
  }
}
