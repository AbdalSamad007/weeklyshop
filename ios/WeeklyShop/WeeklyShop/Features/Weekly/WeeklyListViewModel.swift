//
//  WeeklyListViewModel.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 16/02/2026.
//

import Foundation
import Combine

@MainActor
final class WeeklyListViewModel: ObservableObject {

    @Published private(set) var weeklyItems: [WeeklyItem] = []
    @Published private(set) var masterItems: [MasterItem] = []
    @Published private(set) var catalogItems: [CatalogItem] = []

    @Published var newItemName: String = ""
    @Published var showingAddSheet: Bool = false

    private let repository: WeeklyRepository

    init(repository: WeeklyRepository) {
        self.repository = repository

        Task {
            await initialize()
        }
    }

    // MARK: - Initialization

    private func initialize() async {
    
        await repository.seedMasterIfNeeded()
        await repository.seedCatalogIfNeeded()

        // IMPORTANT: Load AFTER seeding
        await loadAll()

        // Now masterItems should NOT be empty
        if weeklyItems.isEmpty {
            await repository.resetWeek(masterItems: masterItems)
            await loadAll()
        }
    }



    // MARK: - Load

    func loadAll() async {
        weeklyItems = await repository.fetchWeeklyItems()
        masterItems = await repository.fetchMasterItems()
        catalogItems = await repository.fetchCatalogItems()
    }

    // MARK: - Weekly Actions

    func toggleItem(_ item: WeeklyItem) {
        Task {
            await repository.toggleItem(item)
            await loadAll()
        }
    }

    func delete(at offsets: IndexSet) {
        Task {
            await repository.delete(at: offsets, from: weeklyItems)
            await loadAll()
        }
    }

    func resetWeek() {
        Task {
            await repository.resetWeek(masterItems: masterItems)
            await loadAll()
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

            await loadAll()
        }
    }
}



