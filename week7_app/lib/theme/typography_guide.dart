import 'package:flutter/material.dart';

/// Standard typography roles used across the app.
/// Every Text in the app goes through one of these helpers, so sizes and
/// fonts come from the theme and can be changed in one place.
class AppText {
  static Text _build(
    BuildContext c,
    String s,
    TextStyle? style, {
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    TextAlign? align,
  }) {
    return Text(
      s,
      style: color == null ? style : style?.copyWith(color: color),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: align,
    );
  }

  static Text display(BuildContext c, String s,
          {int? maxLines, TextOverflow? overflow, Color? color, TextAlign? align}) =>
      _build(c, s, Theme.of(c).textTheme.displaySmall,
          maxLines: maxLines, overflow: overflow, color: color, align: align);

  static Text headline(BuildContext c, String s,
          {int? maxLines, TextOverflow? overflow, Color? color, TextAlign? align}) =>
      _build(c, s, Theme.of(c).textTheme.headlineSmall,
          maxLines: maxLines, overflow: overflow, color: color, align: align);

  static Text title(BuildContext c, String s,
          {int? maxLines, TextOverflow? overflow, Color? color, TextAlign? align}) =>
      _build(c, s, Theme.of(c).textTheme.titleLarge,
          maxLines: maxLines, overflow: overflow, color: color, align: align);

  static Text subtitle(BuildContext c, String s,
          {int? maxLines, TextOverflow? overflow, Color? color, TextAlign? align}) =>
      _build(c, s, Theme.of(c).textTheme.titleMedium,
          maxLines: maxLines, overflow: overflow, color: color, align: align);

  static Text body(BuildContext c, String s,
          {int? maxLines, TextOverflow? overflow, Color? color, TextAlign? align}) =>
      _build(c, s, Theme.of(c).textTheme.bodyLarge,
          maxLines: maxLines, overflow: overflow, color: color, align: align);

  static Text caption(BuildContext c, String s,
          {int? maxLines, TextOverflow? overflow, Color? color, TextAlign? align}) =>
      _build(c, s, Theme.of(c).textTheme.bodySmall,
          maxLines: maxLines,
          overflow: overflow,
          color: color ?? Theme.of(c).colorScheme.onSurfaceVariant,
          align: align);
}
