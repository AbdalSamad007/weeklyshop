# Technical Decisions

This document explains key technical choices made during development.

---

## SwiftUI
SwiftUI was chosen because:
- It is Apple’s modern UI framework
- Enables faster UI development
- Integrates well with SwiftData and CloudKit

---

## MVVM Architecture
MVVM was selected to:
- Separate UI from business logic
- Improve maintainability
- Make the code easier to test and scale

---

## Local Persistence
The app will start with:
- SwiftData (preferred) or Core Data

Reasons:
- Offline-first design
- Fast local performance
- Native iOS support

---

## CloudKit for Sync (Planned)
CloudKit was chosen because:
- Native Apple solution
- Built-in sharing features
- No separate backend required
- Good fit for family-based data

---

## MVP-First Approach
Development will focus on:
1. Core weekly reset functionality
2. Simple, clean user experience
3. Gradual feature additions

This reduces complexity and speeds up time to first release.

