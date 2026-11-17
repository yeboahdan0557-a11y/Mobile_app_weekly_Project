import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Screen-width limits (in logical pixels) used by the responsive layout.
class Breakpoints {
  static const double tablet = 600; // >= 600 : 2-column grid
  static const double desktop = 1000; // >= 1000: 3-column grid
}

class AppTheme {
  // My own palette (deep purple + raspberry), different from the starter teal.
  static const Color primary = Color(0xFF54217A);
  static const Color secondary = Color(0xFFB83280);
  static const Color surface = Color(0xFFFAF7FC);
  static const Color surfaceVariant = Color(0xFFE9E1F0);

  static ThemeData light() {
    // fromSeed builds a full Material 3 colour scheme from one seed colour.
    // I then pin the colours I want to be exact.
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          onPrimary: Colors.white,
          secondary: secondary,
          onSecondary: Colors.white,
          surface: surface,
        );

    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final text = base.textTheme.apply(
      fontFamily: GoogleFonts.inter().fontFamily,
    );

    return base.copyWith(
      scaffoldBackgroundColor: surface,
      textTheme: text,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      // Card margin is zero on purpose: spacing comes from the list/grid,
      // so the same card looks right in a list AND in a grid.
      cardTheme: CardThemeData(
        elevation: 2,
        margin: EdgeInsets.zero,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        // Without focusedBorder the field gives no sign that it is active,
        // because `border` above has no line at all.
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB3261E), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB3261E), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primary),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surfaceVariant,
        selectedColor: primary,
        checkmarkColor: Colors.white,
        // The label colour has to depend on the chip state: white when
        // selected, dark when not. A plain TextStyle colour cannot do that,
        // so I use WidgetStateColor.
        labelStyle: text.labelLarge?.copyWith(
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.white
                : Colors.black87,
          ),
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
