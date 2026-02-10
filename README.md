# WeeklyShop 🛒
**Set it once. Shop every week.**

WeeklyShop is a family shopping list app that automatically resets every week from a master list, so you never have to rebuild the same grocery list again.

> Status: In active development (MVP phase)

---

## Overview
Most shopping list apps require users to:
- Recreate the same list every week, or
- Manually clear and duplicate lists

WeeklyShop introduces a simple, repeatable workflow:

**Master List (recurring items)**  
→ **Weekly List (active shopping list)**  
→ **Automatic weekly reset**  
→ Repeat

This removes repetitive setup and makes weekly shopping effortless.

---

## Core Features (MVP)
- Master list for recurring grocery items
- Weekly list generated automatically
- Temporary items that last for one week only
- Simple shopping mode with quick check-off
- Manual weekly reset (auto-reset planned)

---

## Planned Features
- Family sharing with real-time sync
- Multiple households (e.g., Home, Work, Uni)
- Home screen widgets
- Optional smart suggestions

---

## Tech Stack
- **Platform:** iOS
- **Language:** Swift
- **UI:** SwiftUI
- **Architecture:** MVVM
- **Local storage:** SwiftData (or Core Data)
- **Sync (planned):** CloudKit

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

## Roadmap
See the full development plan:  
`docs/roadmap.md`

---

## Architecture
High-level system design:  
`docs/architecture.md`

---

## License
MIT License (to be added).
