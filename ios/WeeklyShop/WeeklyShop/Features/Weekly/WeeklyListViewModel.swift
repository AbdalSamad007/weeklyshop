//
//  WeeklyListViewModel.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 16/02/2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class WeeklyListViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var weeklyItems: [WeeklyItem] = []
    @Published private(set) var masterItems: [MasterItem] = []
    @Published private(set) var catalogItems: [CatalogItem] = []

    @Published var newItemName: String = ""
    @Published var showingAddSheet: Bool = false

    // 🔥 Undo Support
    @Published var recentlyDeletedItem: WeeklyItem?


    // MARK: - Dependencies

    private let repository: WeeklyRepository


    // MARK: - Init

    init(repository: WeeklyRepository) {
        self.repository = repository

        // Real-time Firestore listener
        if let firestoreRepo = repository as? FirestoreWeeklyRepository {
            Task {
                for await items in firestoreRepo.weeklyItemsStream() {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        self.weeklyItems = items
                    }
                }
            }
        }

        Task {
            await initialize()
        }
    }


    // MARK: - Initialization

    private func initialize() async {
        await repository.seedMasterIfNeeded()
        await repository.seedCatalogIfNeeded()

        await loadNonRealtimeData()

        if weeklyItems.isEmpty {
            await repository.resetWeek(masterItems: masterItems)
        }
    }


    // MARK: - Loading (Non-Realtime Only)

    private func loadNonRealtimeData() async {
        masterItems = await repository.fetchMasterItems()
        catalogItems = await repository.fetchCatalogItems()
    }


    // MARK: - Weekly Actions

    func toggleItem(_ item: WeeklyItem) {
        Task {
            await repository.toggleItem(item)
            // No loadAll() — snapshot listener handles updates
        }
    }


    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let item = weeklyItems[index]

        recentlyDeletedItem = item

        Task {
            await repository.delete(item)
        }

        // Auto-dismiss undo after 3 seconds
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            if self.recentlyDeletedItem?.id == item.id {
                self.recentlyDeletedItem = nil
            }
        }
    }


    func undoDelete() {
        guard let item = recentlyDeletedItem else { return }

        Task {
            await repository.addItem(name: item.name)
        }

        recentlyDeletedItem = nil
    }


    func resetWeek() {
        Task {
            await repository.resetWeek(masterItems: masterItems)
            // Snapshot listener updates weeklyItems automatically
        }
    }


    func addWeeklyItem(named name: String, alsoSaveToCatalog: Bool = false) {
        Task {
            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }

            let alreadyInWeekly = weeklyItems.contains {
                $0.name.lowercased() == trimmed.lowercased()
            }

            if !alreadyInWeekly {
                await repository.addItem(name: trimmed)
            }

            if alsoSaveToCatalog {
                let exists = catalogItems.contains {
                    $0.name.lowercased() == trimmed.lowercased()
                }

                if !exists {
                    await repository.addCatalogItem(name: trimmed)
                }
            }

            newItemName = ""
            showingAddSheet = false
        }
    }
}

