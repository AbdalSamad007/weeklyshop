# WeeklyShop 🛒
**Set it once. Shop every week.**

WeeklyShop is a family shopping list app that automatically resets every week from a master list. It removes the need to recreate the same grocery list repeatedly and simplifies the weekly shopping routine for households.

> Status: v0.1 – Phase 1 complete (app foundation finished)

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

**Master List (recurring items)**  
→ **Weekly List (active shopping list)**  
→ **Weekly reset**  
→ Repeat

This ensures:
- Core items are always present
- Temporary items do not clutter future lists
- Families can collaborate on one shared list

---

## Core Concepts

### Master List
A permanent list of recurring items that form the base of each week’s shopping list.

### Weekly List
The active shopping list for the current week.  
Generated automatically from the Master List.

### Temporary Items
Items added for one week only (e.g., snacks, special ingredients).

---

## Core Features (MVP)
- Master list for recurring grocery items
- Weekly list generated from master list
- Temporary items that last one week only
- Simple shopping mode
- Manual weekly reset

---

## Development Status

### v0.1 – Phase 1 Complete
The foundational app structure is now complete:

- iOS SwiftUI project initialized
- Tab-based navigation (Weekly, Master, Settings)
- Core data model created
- Project structure organized into App, Features, and Models
- Phase 1 pushed with clean commit history

Next milestone:  
**v0.2 – Working weekly shopping list (add, check, delete, reset).**

---

## Planned Features
- Family sharing with real-time sync
- Multiple households
- Widgets for quick access
- Optional smart restock suggestions
- Custom weekly reset schedule

---

## Target Users
WeeklyShop is designed for:
- Families sharing grocery responsibilities
- Couples managing a household
- Students or shared housing
- Anyone with a repeating weekly shop

---

## Tech Stack
- Platform: iOS
- Language: Swift
- UI Framework: SwiftUI
- Architecture: MVVM
- Local Storage: SwiftData (or Core Data)
- Sync (planned): CloudKit

---

## Project Structure

weeklyshop/
README.md
docs/
architecture.md
decisions.md
roadmap.md
screenshots/
ios/

---

## Development Philosophy
WeeklyShop follows a **minimal, focused product approach**:

- Solve one core problem extremely well
- Keep the interface simple and fast
- Avoid unnecessary complexity
- Build incrementally from a strong MVP

---

## Roadmap
Full roadmap available at:
`docs/roadmap.md`

---

## Architecture
High-level design:
`docs/architecture.md`

---

## License
MIT License (to be added).

