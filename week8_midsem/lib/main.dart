import 'package:flutter/material.dart';

import 'screens/event_list_screen.dart';

void main() {
  runApp(const CampusTicketingApp());
}

class CampusTicketingApp extends StatelessWidget {
  const CampusTicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Event Ticketing System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E), // Variant 0 Primary Color
          secondary: const Color(0xFFF59E0B), // Variant 0 Secondary Color
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F766E),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const EventListScreen(),
    );
  }
}
