# WeeklyShop Architecture

## System Overview
WeeklyShop is built around a simple weekly cycle.

A permanent **Master List** generates a fresh **Weekly List** every week.  
Temporary items exist only within the weekly cycle.

---

## Design Principles
- Offline-first architecture
- Minimal user input required
- Predictable weekly behavior
- Clear separation of concerns

---

## Core Components

### Master List
The permanent set of recurring grocery items.

Responsibilities:
- Store base household items
- Persist across all weeks
- Serve as the source for weekly generation

---

### Weekly List
The active list used for the current shopping cycle.

Responsibilities:
- Track checked/unchecked items
- Accept temporary items
- Reset each week

---

### Item Types

#### Recurring Item
- Stored in Master List
- Automatically appears each week

#### Temporary Item
- Exists only in Weekly List
- Removed during reset

---

## Data Model (Conceptual)

### Household
Represents a shared shopping environment.

Properties:
- id
- name
- members

Contains:
- Master List
- Weekly List

---

### Item
Properties:
- id
- name
- quantity (optional)
- note (optional)
- isChecked (boolean)
- isRecurring (boolean)

---

## Weekly Reset Logic (MVP)
When a reset is triggered:

1. Clear the current Weekly List
2. Copy all Master List items
3. Set all items to unchecked
4. Do not carry over temporary items

---

## Future Sync Architecture
Planned approach:
- CloudKit shared database
- One shared household container
- Real-time syncing across devices

Conflict strategy:
- Initial: last write wins
- Future: merge-based logic if needed

---

## App Architecture Pattern
WeeklyShop uses **MVVM**:

### Model
- Data structures
- Persistence logic

### ViewModel
- Business rules
- Weekly reset logic
- Item management

### View
- SwiftUI interface
- User interaction
