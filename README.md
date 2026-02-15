# WeeklyShop 🛒  
Set it once. Shop every week.

WeeklyShop is a family shopping list app that automatically resets every week from a master list. It removes the need to recreate the same grocery list repeatedly and simplifies the weekly shopping routine for households.

---

## Status

v0.2 – Phase 2 Complete (Working MVP)

WeeklyShop now has a fully functional core experience with persistent local storage and weekly reset logic.

Next milestone: Phase 3 – Real-world testing on device.

---

## Problem

Most households buy many of the same groceries every week:

- Milk  
- Bread  
- Eggs  
- Fruit  
- Household essentials  

However, most shopping list apps require users to:

- Recreate the same list every week, or  
- Manually clear and duplicate lists  

This creates unnecessary friction in a task that should be simple and repeatable.

---

## Solution

WeeklyShop introduces a structured weekly cycle:

Master List (recurring items)  
→ Weekly List (active shopping list)  
→ Weekly reset  
→ Repeat  

This ensures:

- Core items are always present  
- Temporary items do not clutter future lists  
- Families can collaborate on one shared list (planned)

---

## Core Features (MVP)

- Master list for recurring grocery items  
- Weekly list generated from master list  
- Temporary items that last one week only  
- Manual weekly reset  
- Persistent local storage (SwiftData)  
- Empty state handling  

---

## Development Status

### v0.1 – Phase 1 Complete
- iOS SwiftUI
