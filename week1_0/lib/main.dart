// AI-assisted: Generated with Gemini on October 14, 2026. Modified by Yeboah Daniel.

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INFT 425 - Yeboah Daniel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo, // Customized primary color
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with Course Code and Actual Name
      appBar: AppBar(
        title: const Text('INFT 425 - Yeboah Daniel'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment centers children vertically in Column
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hello World Text Widget with custom styling
            const Text(
              'Hello World',
              style: TextStyle(
                fontSize: 36, // Customized font size (changed from 40 to 36)
                fontWeight: FontWeight.bold,
                color: Colors.red, // Customized text color (changed from blue to purple)
              ),
            ),

            // Spacing between widgets
            const SizedBox(height: 16),

            // Material Icon for Code Symbol
            const Icon(Icons.code, color: Colors.green, size: 50),

            const SizedBox(height: 16),

            // Department Name Subtitle Widget
            const Text(
              'Department of Computing Sciences and Engineering',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 12),

            // Extra Custom Widget (Valley View University tag)
            const Text(
              'Valley View University',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
