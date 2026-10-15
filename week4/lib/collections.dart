void main() {
  // Part 3 & 4: Lists
  List<String> movies = [
    'Inception',
    'Interstellar',
    'The Dark Knight',
    'Gladiator',
  ];
  movies.add('Avatar');
  movies.removeAt(0);
  print('Movies list: $movies');

  // Part 5 & 6: Maps
  Map<String, int> movieYears = {
    'Inception': 2010,
    'Interstellar': 2014,
    'Gladiator': 2000,
  };
  print('Movie year for Interstellar: ${movieYears['Interstellar']}');

  // Part 7 & 8: Sets
  Set<String> subjects = {'Math', 'Physics', 'Programming', 'Math'};
  subjects.add('Database');
  print('Unique subjects: $subjects');
}
