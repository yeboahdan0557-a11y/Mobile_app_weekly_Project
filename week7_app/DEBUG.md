# Week 7 – DEBUG.md

**Name:** Yeboah Daniel
**Branch:** `week7-styling`

## Bugs found in the Week 7 starter code (by checking it against the spec)

### 1. `CardTheme` does not compile
- **Problem:** `cardTheme: CardTheme(...)`. On current Flutter, `ThemeData.cardTheme` expects `CardThemeData`, so the app does not compile.
- **Fix:** Use `CardThemeData(...)`.

### 2. Starter colours are the same for every student
- **Problem:** The starter colours `#0F766E` and `#F59E0B` are shared by everyone. Using the same colours as another student costs −100 for both.
- **Fix:** My own palette: primary `#54217A` and secondary `#B83280`.

### 3. Selected chip text stayed dark
- **Problem:** `labelStyle` was fixed to `black87`, and the selected label colour was not state-aware, so dark text sat on a purple chip.
- **Fix:** `WidgetStateColor.resolveWith` in `chipTheme.labelStyle`: white when selected, dark otherwise.

### 4. Card margin broke the grid
- **Problem:** The theme gave every card a margin of 16 horizontal and 6 vertical. In the grid, cards were indented twice and could be clipped.
- **Fix:** Card margin is zero in the theme. Spacing comes from the list padding and the grid spacing.

### 5. No focus indicator on text fields
- **Problem:** `border` had `BorderSide.none` and there was no `focusedBorder`, so a focused field looked the same as an unfocused one. Error borders were also invisible.
- **Fix:** Added `focusedBorder`, `errorBorder` and `focusedErrorBorder` to the input theme.

### 6. Per-field borders overrode the theme
- **Problem:** The Week 6 fields still had `border: OutlineInputBorder(...)`, which the spec forbids.
- **Fix:** Removed the per-field borders from the search field, the form fields and the dropdown.

### 7. Inline style on the form button
- **Problem:** The form button still had an inline `style:`, but the spec says buttons use the theme style.
- **Fix:** Removed it. `elevatedButtonTheme` now sets the size, colour and shape.

### 8. Grid cells could overflow
- **Problem:** `childAspectRatio` of 2.4 and 2.6 makes the cell height depend on the width, so content can overflow at some sizes.
- **Fix:** `mainAxisExtent: 104`, a fixed cell height.

### 9. `AppText` was too limited
- **Problem:** The helpers had no `maxLines`, `overflow` or `color`. Long titles overflowed, and white text on the header was impossible.
- **Fix:** Added optional parameters to every helper.

### 10. Empty state used the wrong values
- **Problem:** It used `_searchQuery.isNotEmpty` and `_selectedCategory`. A spaces-only search showed the wrong message, and a category that no longer exists showed a wrong one.
- **Fix:** Use the trimmed query and `_activeCategory`.

### 11. Scaffold background was the default
- **Problem:** The `surface` colour defined in the theme was never used.
- **Fix:** `scaffoldBackgroundColor: surface`.

### 12. Default Material colours on the FAB and spinner
- **Problem:** Default Material blue or purple costs −10.
- **Fix:** Added `floatingActionButtonTheme` and `progressIndicatorTheme` to the theme.

### 13. Inline `fontSize` in the Week 6 screens
- **Problem:** The spec says zero inline `fontSize` outside the theme (−10).
- **Fix:** Replaced all of them with `AppText` roles. `flutter test` also checks this.

## AI Prototyping — Detail Screen
- **What AI suggested:** A bottom action row with large, equal-width Edit and Delete buttons, with Delete shown in the error colour.
- **Why I agreed:** The icons in my AppBar were small and easy to miss. A bottom row is easier to reach with a thumb, and a red outlined Delete makes the destructive action obvious.
- **What I implemented:** In `detail_screen.dart`, a `Row` of two `Expanded` buttons at the bottom of the screen, inside a `SafeArea`: an `ElevatedButton.icon` for Edit (using the app theme) and an `OutlinedButton.icon` for Delete (with the error colour as a one-off). Both call the same `onEdit` and `onDelete` as the AppBar icons.
- **Visual result:** Before: only two small icons at the top right. After: the same icons stay at the top, and there are also two wide buttons at the bottom of the screen.