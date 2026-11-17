import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_app/models/item.dart';
import 'package:week7_app/screens/detail_screen.dart';
import 'package:week7_app/screens/item_form_screen.dart';
import 'package:week7_app/theme/app_theme.dart';

Item _sample() => Item(
      id: 'abc',
      title: 'First Item',
      subtitle: 'Sub',
      description: 'A long enough description.',
      category: 'General',
      createdAt: DateTime(2025, 1, 15),
    );

void main() {
  group('Item model', () {
    test('toJson then fromJson gives back the same data', () {
      final original = _sample();
      final copy = Item.fromJson(original.toJson());
      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.createdAt, original.createdAt);
    });

    test('copyWith never changes id or createdAt', () {
      final original = _sample();
      final edited = original.copyWith(title: 'New title');
      expect(edited.title, 'New title');
      expect(edited.id, original.id);
      expect(edited.createdAt, original.createdAt);
    });
  });

  group('Week 7 rules', () {
    test('breakpoints are 600 and 1000', () {
      expect(Breakpoints.tablet, 600);
      expect(Breakpoints.desktop, 1000);
    });

    test('no inline font size outside app_theme.dart', () {
      final offenders = <String>[];
      for (final f in Directory('lib').listSync(recursive: true)) {
        if (f is! File) continue;
        if (!f.path.endsWith('.dart') || f.path.endsWith('app_theme.dart')) {
          continue;
        }
        if (f.readAsStringSync().contains('fontSize')) offenders.add(f.path);
      }
      expect(offenders, isEmpty);
    });
  });

  testWidgets('detail screen shows fields and action buttons', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DetailScreen(item: _sample(), onEdit: () {}, onDelete: () {}),
    ));
    expect(find.text('First Item'), findsOneWidget);
    expect(find.text('Sub'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
    expect(find.text('A long enough description.'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  group('form validation', () {
    Future<void> submitTitle(WidgetTester tester, String title) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MaterialApp(home: ItemFormScreen()));
      await tester.enterText(find.byType(TextFormField).at(0), title);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
    }

    testWidgets('rejects whitespace-only title', (tester) async {
      await submitTitle(tester, '   ');
      expect(find.text('Title is required'), findsOneWidget);
    });

    testWidgets('rejects a 2-character title', (tester) async {
      await submitTitle(tester, 'ab');
      expect(find.text('At least 3 characters'), findsOneWidget);
    });

    testWidgets('rejects a 60-character title', (tester) async {
      await submitTitle(tester, 'a' * 60);
      expect(find.text('At most 50 characters'), findsOneWidget);
    });
  });
}
