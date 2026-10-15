# Prompt Customization Log — Yeboah Daniel

## Week 2

### Prompt 1: First Dart Program

- **Tool used:** Gemini AI / VS Code Terminal
- **What I changed:** Created a new file `lib/week2_dart_basics.dart` to establish the entry point for Week 2 logic.
- **What I produced:** A structural Dart script with a `main()` function demonstrating basic data types (`String`, `int`, `double`, `bool`) and terminal execution.
- **What I fixed:** Ensured proper file path configuration for running pure Dart files via `dart run`.
- **What I learned:** How to set up and execute standalone Dart scripts without needing the full Flutter UI widget tree.

### Prompt 2: Personal Info Program

- **Tool used:** Gemini AI
- **What I changed:** Adapted variables to reflect personal academic tracking (Student Name, Course Code 425, Target GPA).
- **What I produced:** Strongly typed variable declarations and console prints for academic profile tracking.
- **What I fixed:** Verified type safety and syntax rules for Dart variable scoping.
- **What I learned:** The difference between explicit type declarations and how Dart infers types.

### Prompt 3: String Interpolation

- **Tool used:** Gemini AI
- **What I changed:** Implemented dynamic text formatting using dollar-sign syntax inside print statements.
- **What I produced:** Clean output lines combining static strings with variable values (e.g., `Student: $studentName`) and inline ternary expressions (`${gpa >= 3.0 ? 'Good Standing' : 'Needs Improvement'}`).
- **What I fixed:** Wrapped complex expressions inside curly brackets `{}` inside the string interpolation blocks to avoid parser errors.
- **What I learned:** How to cleanly embed variables and conditional logic directly into strings without messy string concatenation.

### Prompt 4: Operators

- **Tool used:** Gemini AI
- **What I changed:** Added relational operators (`>=`, `<`) and `if/else` control flow structures.
- **What I produced:** A `calculateGrade` function that evaluates numeric test scores and returns letter grades with descriptive labels.
- **What I fixed:** Ordered score boundaries correctly from highest to lowest to prevent logical cutoff bugs in the conditional ladder.
- **What I learned:** Applying comparison operators and multi-branch control flow statements to manage application decision-making.

### Prompt 5: My Own Experiment

- **Tool used:** Gemini AI / VS Code
- **What I changed:** Experimented with named parameters (`{required ...}`) and null safety operators (`?` and `??`).
- **What I produced:** A custom function `displayStudentSummary` utilizing required named parameters and a nullable middle name check with a default fallback value.
- **What I fixed:** Handled null safety requirements by explicitly declaring nullable types (`String?`) and applying the null-coalescing operator (`??`).
- **What I learned:** How Dart's modern null safety features prevent runtime null-pointer exceptions and how named parameters improve function readability.
