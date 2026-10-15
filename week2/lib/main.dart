// INFT 425 - Week 2: Dart Fundamentals & Control Flow
// Student: Yeboah Daniel
// Institution: Valley View University

void main() {
  print('=== WEEK 2: DART FUNDAMENTALS ===\n');

  // 1. Variables & Data Types
  String studentName = 'Yeboah Daniel';
  int courseCode = 425;
  double targetGpa = 3.8;
  bool isEnrolled = true;

  print('Student: $studentName');
  print('Course: INFT $courseCode');
  print('Target GPA: $targetGpa');
  print('Enrolled: $isEnrolled\n');

  // 2. Control Flow & Operators
  double testScore = 85.5;
  String gradeResult = calculateGrade(testScore);
  print('Test Score: $testScore');
  print('Calculated Grade: $gradeResult\n');

  // 3. Null Safety Demonstration
  String? middleName; // Nullable String
  String displayName = middleName ?? 'No Middle Name Provided';
  print('Middle Name Check: $displayName\n');      

  // 4. Function Execution with Named Parameters
  displayStudentSummary(
    name: studentName,
    department: 'Department of Computing Sciences and Engineering',
    gpa: targetGpa,
  );
}

// Function with Control Flow (if / else if / else)
String calculateGrade(double score) {
  if (score >= 80) {
    return 'A (Excellent)';
  } else if (score >= 70) {
    return 'B (Very Good)';
  } else if (score >= 60) {
    return 'C (Good)';
  } else if (score >= 50) {
    return 'D (Pass)';
  } else {
    return 'F (Fail)';
  }
}

// Function with Required Named Parameters and Ternary Operator
void displayStudentSummary({
  required String name,
  required String department,
  required double gpa,
}) {
  print('--- Academic Summary ---');
  print('Name: $name');
  print('Department: $department');
  print('Academic Status: ${gpa >= 3.0 ? 'Good Standing' : 'Needs Improvement'}');
}