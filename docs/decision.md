# Technical Decisions

This document explains the reasoning behind major technical choices.

---

## SwiftUI
Chosen because:
- Modern Apple UI framework
- Faster UI iteration
- Cleaner declarative syntax
- Native integration with new iOS APIs

---

## MVVM Architecture
MVVM was selected to:
- Separate UI from business logic
- Improve maintainability
- Make the code easier to test
- Allow future scaling

---

## Local Persistence
Initial storage will use:
- SwiftData (preferred)
- Core Data (fallback)

Reasons:
- Offline-first experience
- Fast local performance
- Native Apple support

---

## CloudKit for Sync (Planned)
CloudKit was chosen because:
- Native iOS integration
- Built-in data sharing
- No separate backend required
- Suitable for small family datasets

---

## Offline-First Approach
The app is designed to:
- Work fully offline
- Sync changes when network is available
- Avoid reliance on constant connectivity

This improves reliability during shopping trips.

---

## MVP-First Development Strategy
Development will follow a staged approach:

1. Build a strong local-only core
2. Add sharing and sync
3. Polish the user experience
4. Release publicly

This reduces complexity and shortens time to first usable version.
