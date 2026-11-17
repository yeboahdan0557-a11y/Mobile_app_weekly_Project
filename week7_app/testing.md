# Week 7 – TESTING.md

**Name:** Yeboah Daniel
**Course:** INFT 425
**Branch:** `week7-styling`
**Theme:** Music Playlist (Highlife / Hip-hop / Gospel)

## 1. Test checklist

All items below were run on my emulator or phone and passed (✔).

### Theme and styling
- ✔ AppBar is deep purple (#54217A) with a white, left-aligned title.
- ✔ Cards have 12 px rounded corners and no inline elevation.
- ✔ Search and form fields are filled grey-lilac with no border line, and get a purple border when focused.
- ✔ Elevated buttons are purple with white text and rounded corners. The form button is full width.
- ✔ The selected chip has a purple background with white text. Unselected chips are grey with dark text.
- ✔ Text uses the Inter font from Google Fonts (needs internet the first time the app runs).
- ✔ `grep -rn "fontSize" lib/` shows no results outside `app_theme.dart`.
- ✔ `grep -rn "elevation:" lib/` shows no results outside `app_theme.dart`.

### Responsive layout
- ✔ Phone (under 600 px): single-column list.
- ✔ Between 599 and 601 px: switches from the list to a 2-column grid.
- ✔ Tablet (600–999 px): 2-column grid.
- ✔ Between 999 and 1001 px: switches from 2 columns to 3 columns.
- ✔ Desktop (1000 px and above): 3-column grid, content centred with a maximum width of 1200.
- ✔ No yellow overflow warnings at any width.

### Loading and empty states
- ✔ App starts: spinner with "Loading items...".
- ✔ Delete every item: "No items yet" with "Tap + to add your first item".
- ✔ Search `zzz`: `No results for "zzz"` with "Try a different word".
- ✔ Filter to a category with no items: "No items in [category]" with `Tap "All" to see everything`.
- ✔ Search `zzz` while a category is selected: "No results in [category]" with "Try a different search or clear the filter".

### Animations
- ✔ List load: cards fade in and slide up, one after another.
- ✔ Tap a card: the avatar flies from the card to the detail screen (Hero).
- ✔ Tap the search field: the border turns purple.
- ✔ Add a new item: see the note in section 2.

### Week 6 features still working
- ✔ Search is case-insensitive (`first`, `FIRST`, and a word that only appears in a description).
- ✔ Category filter.
- ✔ All four sort modes work, and the sort choice is kept after a restart.
- ✔ Add, edit (the detail screen closes and the list updates) and delete (Cancel keeps the item, confirm removes it).
- ✔ Data survives closing and reopening the app.
- ✔ Swipe to delete with confirmation and Undo.
- ✔ Pull to refresh.

### Automated checks
- ✔ `flutter analyze`
- ✔ `flutter test`
- ✔ `flutter build apk --release`

## 2. Known limitation: card animation

The cards use `TweenAnimationBuilder`. It animates once when a widget is first built. Each card has a key made from its id, so a card that appears for the first time (including a newly added one) should animate. However, cards that scroll out of view and back in are rebuilt and play the animation again. A proper per-item insert animation would use `AnimatedList`. That is out of scope for this week, so I left it as is.

When I added a new item, it ______________ (fades in / appears without animation). ← fill this in from what you saw.

## 3. AI UI prototyping (tool used: Claude)

### Prompt I used
```text
You are a senior UI designer. Create a Flutter widget tree (no code) for a
Music Playlist app detail screen. It shows:
- A header with an icon and title
- 3 sections: "Overview", "Details", "Notes"
- An action row at the bottom with Edit and Delete buttons
- Uses Material 3

Output as a nested bullet list showing each widget, its role, and one line
explaining why it is there. Do not output Dart code.
```

### AI output
- **Scaffold**: root of the screen. It provides the app bar, body and background from the Material 3 theme.
  - **AppBar**: shows the screen title and a back button. It follows the theme colours, so the colours are not hardcoded.
  - **SafeArea**: keeps content away from notches and the system bar.
    - **LayoutBuilder**: reads the available width. It lets the layout switch between phone, tablet and desktop.
      - **Center + ConstrainedBox (max width 720)**: stops the content stretching on wide screens.
        - **Column**: stacks the header, sections and actions.
          - **Header Card (filled tonal)**: groups the key identity of the song.
            - **Row**
              - **CircleAvatar with a music-note Icon**: a quick visual identity for the song.
              - **Column**
                - **Text (headlineSmall)**: the song title, the most important text.
                - **Text (bodyMedium, onSurfaceVariant)**: the artist, with softer emphasis.
                - **Chip**: the genre, so it is visible at a glance.
          - **Section "Overview"**
            - **Text (titleMedium)**: section label for scanning.
            - **Text (bodyLarge)**: the song description in readable body text.
          - **Section "Details"**
            - **Text (titleMedium)**: section label.
            - **ListTile × 2 (leading icon, title, subtitle)**: genre and date added as labelled rows.
          - **Section "Notes"**
            - **Text (titleMedium)**: section label.
            - **Text (bodyMedium) or an empty hint "No notes yet"**: personal notes, with a clear empty state.
          - **Spacer / SizedBox (24)**: breathing room before the actions.
    - **Bottom action row (inside SafeArea, pinned to the bottom)**
      - **Row with two Expanded children**: equal-width, thumb-friendly buttons.
        - **FilledButton.icon "Edit"**: the primary action.
        - **OutlinedButton.icon "Delete" (colour from colorScheme.error)**: a clear destructive action that does not compete with Edit.
  - **Hero** on the avatar: smooth transition from the list.

### Critique

1. **Material 3 roles or hardcoded values?** Mostly Material 3 roles: it uses text styles such as headlineSmall and titleMedium, `onSurfaceVariant`, and `colorScheme.error`, so it follows the theme. A few things are fixed numbers (the 720 max width and the 24 spacer), which is normal for layout but should live in constants.
2. **Widgets I would not have chosen.** I would not use a `LayoutBuilder` on a detail screen of this size, because a `ConstrainedBox` already handles wide screens. I would also use my own `ElevatedButton` theme instead of `FilledButton`, so the buttons match the rest of my app.
3. **Is it responsive?** Partly. The max-width box handles tablet and desktop by keeping content centred, but it does not change the arrangement (for example a two-column layout on desktop). It is acceptable for a detail page.
4. **What my detail screen was missing.** A bottom action row with large Edit and Delete buttons (mine only had small icons in the AppBar), and a clear structure of labelled sections. It also suggests a Notes section, which my data model does not have.
5. **What is better in the AI design.** The pinned action row is easier to reach with a thumb and makes the destructive action obvious. The tidy section structure and the empty-state hint are also better than my plain text block.

## 4. What I changed because of it
Added the bottom Edit and Delete action row to `detail_screen.dart` (see `DEBUG.md`).