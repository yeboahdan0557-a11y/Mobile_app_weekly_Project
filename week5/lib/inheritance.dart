// ===== Week 5 – Part 4: Inheritance =====

// Parent (base) class. 'abstract' means you cannot create a Person directly.
abstract class Person {
  String name;
  int age;

  Person({required this.name, required this.age});

  // Abstract method: no body. Every subclass MUST provide one.
  String role();

  // Concrete method: written once here, inherited by every subclass.
  void introduce() {
    print('My name is $name');
  }
}

// 'extends' = Lecturer IS-A Person and inherits its fields and methods.
class Lecturer extends Person {
  String department;
  int yearsOfExperience;

  Lecturer({
    required String name,
    required int age,
    required this.department,
    required this.yearsOfExperience,
  }) : super(name: name, age: age); // pass name and age up to Person

  @override
  String role() => 'Lecturer';

  bool isSenior() => yearsOfExperience > 5;
}

class Student extends Person {
  String program;
  double gpa;
  String level;

  Student({
    required String name,
    required int age,
    required this.program,
    required this.gpa,
    required this.level,
  }) : super(name: name, age: age);

  @override
  String role() => 'Student';

  bool isHonors() => gpa >= 3.5;
}

class Administrator extends Person {
  String office;

  Administrator({
    required String name,
    required int age,
    required this.office,
  }) : super(name: name, age: age);

  @override
  String role() => 'Administrator';
}

void main() {
  final lecturer = Lecturer(
      name: 'Dr. Mensah', age: 45, department: 'Computer Science', yearsOfExperience: 12);
  final student = Student(
      name: 'Ama Owusu', age: 21, program: 'Computer Science', gpa: 3.8, level: '300');
  final admin = Administrator(name: 'Mr. Boateng', age: 38, office: 'Block A, Room 4');

  for (final Person p in [lecturer, student, admin]) {
    p.introduce();
    print('Role: ${p.role()}');
    print('---');
  }

  // Child-only methods are called on the child type
  print('Is Ama an honors student? ${student.isHonors()}');
  print('Is Dr. Mensah senior? ${lecturer.isSenior()}');
}