WeeklyShop 🛒

Set it once. Shop every week.

WeeklyShop is a family shopping list app that automatically resets every week from a master list. It removes the need to recreate the same grocery list repeatedly and simplifies the weekly shopping routine for households.

---

Status

v0.3 – Architecture Refactor Complete

WeeklyShop now features a scalable architecture built for long-term growth and real-time collaboration.

Current state:

- Fully functional weekly reset cycle
- Persistent local storage (SwiftData)
- MVVM architecture
- Repository pattern abstraction
- Async-ready data layer
- Session layer foundation

Next milestone: Phase 4 – Firebase Authentication and Real-Time Family Sync.

---

Problem

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

Solution

WeeklyShop introduces a structured weekly cycle:

Master List (recurring items)
→ Weekly List (active shopping list)
→ Weekly reset
→ Repeat

This ensures:

- Core items are always present
- Temporary items do not clutter future lists
- Weekly shopping becomes predictable
- The app remains scalable for family collaboration

Core Features

- Master list for recurring grocery items
- Weekly list generated from master list
- Temporary one-week-only items
- Manual weekly reset
- Persistent local storage (SwiftData)
- Tab-based navigation (Weekly, Master, Settings)
- Clean MVVM architecture
- Repository abstraction layer
- Async-ready data structure

---

Architecture

WeeklyShop follows a layered architecture designed for scalability:

View (SwiftUI)
→ ViewModel (Business Logic)
→ Repository (Protocol Abstraction)
→ Data Layer (SwiftData → Firebase Ready)

Key principles:

- Separation of concerns
- Dependency injection
- Backend-agnostic design
- Cloud-ready structure

The repository layer ensures the app can transition from local storage (SwiftData) to Firebase without rewriting UI or business logic.
