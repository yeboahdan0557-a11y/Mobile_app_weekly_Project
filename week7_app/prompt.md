Prompt Log
Week 7 — Material Design & Styling

1. AI-assisted build of the Week 7 upgrade
   AI tool: Claude
   What I gave it: The Week 7 activity sheet and my Week 6 app.
   What it produced: The theme file, the AppText helper, the three-breakpoint layout, styled loading and empty states, the card animation, and updated screens.
   What I checked: I ran flutter analyze, flutter test and the app on my emulator. I read through each file so I can explain it in the demo.
   What I changed or decided: I chose a theme (Music Playlist) and my own colours so they are different from other students.
2. UI prototyping prompt (Section 8 of the sheet)
   text
   You are a senior UI designer. Create a Flutter widget tree (no code) for a
   Music Playlist app detail screen. It shows:

- A header with an icon and title
- 3 sections: "Overview", "Details", "Notes"
- An action row at the bottom with Edit and Delete buttons
- Uses Material 3

Output as a nested bullet list showing each widget, its role, and one line
explaining why it is there. Do not output Dart code.
Result: A nested widget tree with sections, a header card and a bottom action row. The full output and my critique are in TESTING.md.
What I applied: The bottom Edit/Delete action row in detail_screen.dart (see DEBUG.md). 3. Finding bugs in the starter code
Prompt idea: Compare the Week 7 starter code against the spec table and list every deviation, with the fix for each.
Result: 13 bugs found and fixed. The list is in DEBUG.md.
What I learned

Asking the AI for a design before coding showed me structure I would not have thought of, but I still had to decide which parts fit my app. A design is a starting point, so I judged it against my own app before applying any of it.
