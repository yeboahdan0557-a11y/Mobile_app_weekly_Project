# INFT 425 – Mobile Application Development

**Student:** Yeboah Daniel
**Theme:** Music Playlist (Highlife / Hip-hop / Gospel)

A Flutter app that manages a personal playlist: search, filter, sort, add, edit, delete, swipe-to-delete with undo, pull to refresh, and data saved on the device.

## Week 7 — Material Design & Styling
Branch: `week7-styling`

What I added this week:
- **Material 3 theme** (`lib/theme/app_theme.dart`): my own deep purple and raspberry colours built with `ColorScheme.fromSeed`, Inter font from Google Fonts, and themed AppBar, cards, inputs, buttons and chips.
- **Typography scale** (`lib/theme/typography_guide.dart`): the `AppText` helper. All text uses a theme role, with no inline `fontSize` outside the theme file.
- **Three-breakpoint layout:** phone (< 600) list, tablet (600–999) 2-column grid, desktop (≥ 1000) 3-column grid, content centred at a maximum width of 1200.
- **Loading and empty states:** a themed loader and four distinct empty messages (no items, search, filter, search + filter).
- **Animations:** cards fade in and slide up, and the Hero avatar transition still works.
- **AI UI prototyping:** I prototyped the detail screen with an AI tool, critiqued it, and applied one change (a bottom Edit/Delete action row). See `TESTING.md` and `DEBUG.md`.
- **Week 6 features preserved:** search, filter, sort, add/edit/delete, persistence, swipe with undo, pull to refresh.

## Project structure
```text
lib/
  constants.dart
  main.dart
  data/item_repository.dart
  models/item.dart
  services/storage_service.dart
  theme/app_theme.dart
  theme/typography_guide.dart
  screens/home_screen.dart
  screens/detail_screen.dart
  screens/item_form_screen.dart
test/widget_test.dart
```

## Run it
```bash
flutter pub get
flutter run
```
The first launch needs internet, because Google Fonts downloads the Inter font.

## Test it
```bash
flutter analyze
flutter test
```

## Build the APK
```bash
flutter build apk --release
```
The APK is at `build/app/outputs/flutter-apk/app-release.apk`.

## Documentation
- `TESTING.md`: test results and the AI prototyping critique
- `DEBUG.md`: bugs found in the starter code and the AI-suggested change
- `PROMPT_LOG.md`: prompts used each week