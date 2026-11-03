// ===== Week 5 – Part 2: Classes and Objects =====
class Student {
  // ---- Fields: the data every Student object holds ----
  String name;
  int age;
  String program;
  double gpa;
  List<String> courses;

  // Customisation: honors threshold raised from 3.5 to 3.6.
  // 'static const' = one shared value for the whole class.
  static const double honorsThreshold = 3.6;

  // ---- Constructor with named parameters ----
  // 'required' forces the caller to supply the value.
  // courses is optional; the initializer list gives it an empty list.
  Student({
    required this.name,
    required this.age,
    required this.program,
    required this.gpa,
    List<String>? courses,
  }) : courses = courses ?? [];

  // ---- Method: prints the student's details ----
  void displayInfo() {
    print('Name: $name');
    print('Age: $age');
    print('Program: $program');
    print('GPA: $gpa');
    print('Courses: ${courses.isEmpty ? "none" : courses.join(", ")}');
  }

  // ---- Method: returns a bool ----
  bool isHonors() => gpa >= honorsThreshold;

  // ---- Getter: computed property, called without () ----
  int get ageInMonths => age * 12;

  // ---- Second getter: first letter of each word in the name ----
  String get initials => name
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase())
      .join();

  // ---- Method: adds to the list ----
  void addCourse(String course) {
    courses.add(course);
  }

  // ---- Override: controls what print(student) shows ----
  @override
  String toString() => 'Student: $name';
}

void main() {
  final s1 = Student(name: 'Ama Mensah', age: 22, program: 'Computer Science', gpa: 3.8);
  final s2 = Student(name: 'Kofi Boateng', age: 21, program: 'Information Technology', gpa: 3.2);
  final s3 = Student(name: 'Esi Ansah', age: 23, program: 'Software Engineering', gpa: 3.65);

  final students = [s1, s2, s3];

  for (final s in students) {
    s.displayInfo();                                   // 1. details
    print('Honors student: ${s.isHonors()}');          // 2. honors?
    print('Age in months: ${s.ageInMonths}');          // 3. months
    print(s);                                          // 4. toString()
    print('Initials: ${s.initials}');
    print('---');
  }
}