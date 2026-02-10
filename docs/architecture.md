# WeeklyShop Architecture

## Overview
WeeklyShop is designed around a simple concept:
A permanent **Master List** generates a fresh **Weekly List** every week.

This removes the need to recreate the same shopping list repeatedly.

---

## Core Concepts

### Master List
- Contains recurring items
- Persists across all weeks
- User-defined base grocery list

### Weekly List
- Generated from the Master List
- Used during the current shopping cycle
- Resets every week

### Item Types
Each item can be:

**Recurring**
- Part of the Master List
- Reappears every week

**Temporary**
- Exists only in the Weekly List
- Removed during the next reset

---

## Data Model (Conceptual)

### Household
- Contains one Master List
- Contains one Weekly List

### Item
Properties:
- name
- quantity (optional)
- note (optional)
- isChecked (boolean)
- isRecurring (boolean)

---

## Weekly Reset Logic (MVP)
When reset is triggered:

1. Clear the Weekly List
2. Copy all items from the Master List
3. Set all items to unchecked
4. Do not carry over temporary items

---

## Sync Strategy (Planned)
- CloudKit shared database
- One shared household per family
- Real-time updates
- Initial conflict strategy: last write wins

---

## Architecture Pattern
The app will follow **MVVM**:

- **Model:** Data structures (Household, Item)
- **ViewModel:** Business logic and state
- **View:** SwiftUI interface

