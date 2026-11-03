// ===== Week 5 – Part 13: Student Management System =====

abstract class Person {
  final String name;
  final int id;
  Person(this.name, this.id);

  String getRole(); // each subclass must say what it is

  @override
  String toString() => '$name (ID: $id) - ${getRole()}';
}

class Course {
  final String code;
  final String title;
  final int credits;

  // Private constructor: the only way to build a Course is Course.create
  Course._(this.code, this.title, this.credits);

  // Factory constructor: validates, then returns an object
  factory Course.create({
    required String code,
    required String title,
    required int credits,
  }) {
    if (code.trim().isEmpty || title.trim().isEmpty) {
      throw ArgumentError('Course code and title are required');
    }
    if (credits <= 0) {
      throw ArgumentError.value(credits, 'credits', 'must be greater than zero');
    }
    return Course._(code.trim().toUpperCase(), title.trim(), credits);
  }

  @override
  String toString() => '$code: $title ($credits credits)';
}

// Mixin restricted with 'on Person': only Person subclasses may use it,
// which lets it read 'name'.
mixin Evaluable on Person {
  void submitAssignment() => print('$name submitted an assignment.');
  void takeExam() => print('$name is taking an exam.');
}

class Student extends Person with Evaluable {
  final String program;
  double gpa;
  final List<Course> _courses = [];

  Student(String name, int id, {required this.program, required this.gpa})
      : super(name, id);

  List<Course> get courses => List.unmodifiable(_courses);

  @override
  String getRole() => 'Student';

  // Returns true if enrolled, false if the student was already in the course
  bool enrollIn(Course c) {
    if (_courses.any((x) => x.code == c.code)) {
      print('$name is already enrolled in ${c.code}.');
      return false;
    }
    _courses.add(c);
    print('$name enrolled in ${c.code}.');
    return true;
  }

  int getTotalCredits() => _courses.fold(0, (sum, c) => sum + c.credits);
}

class Lecturer extends Person {
  final String department;
  final List<Course> _teaches = [];

  Lecturer(String name, int id, {required this.department}) : super(name, id);

  List<Course> get teaches => List.unmodifiable(_teaches);

  @override
  String getRole() => 'Lecturer';

  bool assignCourse(Course c) {
    if (_teaches.any((x) => x.code == c.code)) {
      print('$name already teaches ${c.code}.');
      return false;
    }
    _teaches.add(c);
    print('$name now teaches ${c.code}.');
    return true;
  }
}

void main() {
  final c1 = Course.create(code: 'inft425', title: 'Mobile Application Development', credits: 3);
  final c2 = Course.create(code: 'INFT431', title: 'Software Engineering', credits: 4);

  final student = Student('Ama Owusu', 1001, program: 'Computer Science', gpa: 3.8);
  final lecturer = Lecturer('Dr. Mensah', 2001, department: 'Computer Science');

  print('--- Test 1: enroll ---');
  student.enrollIn(c1);
  student.enrollIn(c2);

  print('--- Test 2: assign ---');
  lecturer.assignCourse(c1);

  print('--- Test 3: people and roles ---');
  for (final Person p in [student, lecturer]) {
    print(p);
  }

  print('--- Test 4: total credits ---');
  print('${student.name}: ${student.getTotalCredits()} credits');

  print('--- Test 5: Evaluable mixin ---');
  student.submitAssignment();
  student.takeExam();

  print('--- Break It 1: duplicate enrollment ---');
  student.enrollIn(c1);

  print('--- Break It 2: negative credits ---');
  try {
    Course.create(code: 'BAD100', title: 'Bad Course', credits: -3);
  } catch (e) {
    print('Error: $e');
  }
}