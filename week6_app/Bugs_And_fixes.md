# Week 6 – Bugs and Fixes

**Name:** Yeboah Daniel
**Course:** INFT 425 Mobile Application Development
**App:** Week 6 Flutter app (Home, Detail and Form screens)

---

## Home screen (`home_screen.dart`)

**1. Search only worked with the exact capitalisation**
Typing `FIRST` found nothing, because `contains()` is case-sensitive.
Fix: I turned the search text and the title, subtitle and description into lower case before comparing.

- [ ] `first` and `FIRST` both find "First Item"

**2. Every category chip looked selected**
The chip had `selected: true` written in, so all of them were highlighted.
Fix: `selected: cat == _activeCategory`, so only the tapped one is highlighted.

- [ ] Only one chip is highlighted at a time

**3. The stats bar only showed the total**
It printed "5 items" even when a filter was on.
Fix: it now prints `${items.length} of ${_allItems.length} items`.

- [ ] Tapping Featured shows "2 of 5 items"

**4. The empty message was always the same**
It said "No results for ..." even when the cause was the category filter.
Fix: there are now three messages: one for search, one for a category with nothing in it, and one when there are no items at all.

- [ ] Featured + `zzz` shows the search message
- [ ] An empty category shows the category message

**5. Newest and oldest were swapped**
The compare order was backwards.
Fix: newest first uses `b.createdAt.compareTo(a.createdAt)`, and oldest first uses `a.createdAt.compareTo(b.createdAt)`.

- [ ] Newest first puts the latest item on top

**6. A–Z sort ignored letter case rules**
Capital letters sorted before small letters.
Fix: I lower-cased both titles before comparing.

- [ ] A–Z and Z–A look right with mixed capitals

**7. Cards were cut off in the grid on wide screens**
`childAspectRatio: 5.0` made each cell too short for the content.
Fix: I used a fixed cell height (`mainAxisExtent: 96`), removed the extra card margin inside the grid and added ellipsis for long text.

- [ ] No overflow when I rotate the emulator

**8. Sorting changed the real list**
`var result = _allItems;` doesn't make a copy, so `sort()` reordered the saved data itself.
Fix: `List<Item>.of(_allItems)` makes a copy first.

**9. Stuck on an empty category**
If I deleted the last item of the selected category, no chip was selected and the list was empty.
Fix: `_activeCategory` goes back to "All" when the selected category no longer exists.

- [ ] Deleting the only item in a selected category returns me to All

**10. Pull to refresh did nothing on short lists**
A list that fits on the screen can't scroll, so the refresh never started.
Fix: I added `AlwaysScrollableScrollPhysics()` to the list and grid.

- [ ] Pulling down shows the spinner

---

## Detail, edit and delete

**11. Editing a duplicate title changed the wrong item**
The code found the item by title, so it picked the first match.
Fix: it now finds the item by `id`, which is unique.

- [ ] With two items sharing a title, the one I edit is the one that changes

**12. Detail screen showed old data after an edit**
The detail screen keeps the old item it was given.
Fix: after a successful save, I close the detail screen with `Navigator.pop(context)`.

- [ ] After saving, I'm back on the list with the new title

**13. Cancel still deleted the item**
The code checked `confirmed != null`, and `false` is not null.
Fix: it now checks `confirmed == true`.

- [ ] Delete, then Cancel keeps the item
- [ ] Delete, then confirm removes it and closes the detail screen

**14. The detail screen didn't show every field**
The date the item was created was missing.
Fix: I added an "Added: yyyy-mm-dd" line.

---

## Form (`item_form_screen.dart`)

**15. Three spaces counted as a valid title**
`v.isEmpty` is false for spaces.
Fix: I trim the text first, then check it. I also save the trimmed text.

- [ ] Three spaces shows "Title is required"

**16. Length limits were missing on some fields**
Fix: title is 3 to 50 characters, subtitle has a maximum of 60, description is 10 to 500.

- [ ] `ab` is rejected
- [ ] A 60-character title is rejected

**17. Errors didn't update while typing after a failed save**
Fix: after the first failed submit I switch the form to `AutovalidateMode.always`.

- [ ] After a failed save, the error clears as I type

**18. Controllers were never disposed**
That leaks memory.
Fix: I added `dispose()` to dispose all three controllers.

**19. Possible dropdown crash with an old category**
If a saved item has a category that isn't in the list, the dropdown crashes.
Fix: it falls back to the first category.

---

## Things I changed to make it safer

- **Undo after a swipe delete** puts back only the deleted item, so it can't overwrite other changes.
- **One delete dialog** is used by both the detail screen and the swipe, so Cancel works the same in both.
- **Bottom padding** on the list so the + button doesn't cover the last card.
- **Persistence code** (`storage_service.dart`, `_load`, `_updateAndPersist`) was already correct. I only tested it by adding, editing and deleting, closing the app, and reopening it.
- [ ] Add, edit and delete all survive a restart
- [ ] The sort choice survives a restart

---

## Short explanations for the demo

- **`toJson`:** turns an Item into a Map of simple values (the date becomes text) so it can be saved as one JSON string. `fromJson` does the reverse.
- **`loadItems`:** reads the saved text. If there's nothing saved yet it returns `null` and the app uses the sample items. Otherwise it decodes the list and rebuilds each Item. If the data is damaged it returns `null` instead of crashing.
- **`_filteredItems`:** makes a copy of the list, filters by the search text, filters by category, then sorts by the chosen mode.
