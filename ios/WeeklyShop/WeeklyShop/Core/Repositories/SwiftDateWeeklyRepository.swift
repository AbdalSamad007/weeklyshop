import SwiftData
import Foundation

@MainActor
final class SwiftDataWeeklyRepository: WeeklyRepository {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Weekly

    func fetchWeeklyItems() async -> [WeeklyItem] {
        let descriptor = FetchDescriptor<WeeklyItem>(
            sortBy: [SortDescriptor(\WeeklyItem.name)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func addItem(name: String) async {
        context.insert(WeeklyItem(name: name, isChecked: false))
    }

    func toggleItem(_ item: WeeklyItem) async {
        item.isChecked.toggle()
    }

    func delete(_ item: WeeklyItem) async {
        context.delete(item)
    }

    func delete(at offsets: IndexSet, from items: [WeeklyItem]) async {
        for index in offsets {
            context.delete(items[index])
        }
    }

    func resetWeek(masterItems: [MasterItem]) async {
        let descriptor = FetchDescriptor<WeeklyItem>()
        let existing = (try? context.fetch(descriptor)) ?? []

        existing.forEach { context.delete($0) }

        masterItems.forEach {
            context.insert(WeeklyItem(name: $0.name, isChecked: false))
        }
    }
    
    func seedMasterIfNeeded() async {
        let descriptor = FetchDescriptor<MasterItem>()
        let existing = (try? context.fetch(descriptor)) ?? []

        guard existing.isEmpty else { return }

        let defaults = [
            "Milk", "Eggs", "Bread", "Butter", "Cheese"
        ]

        defaults.forEach {
            context.insert(MasterItem(name: $0))
        }

        try? context.save()
    }


    // MARK: - Master

    func fetchMasterItems() async -> [MasterItem] {
        let descriptor = FetchDescriptor<MasterItem>(
            sortBy: [SortDescriptor(\MasterItem.name)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - Catalog

    func fetchCatalogItems() async -> [CatalogItem] {
        let descriptor = FetchDescriptor<CatalogItem>(
            sortBy: [SortDescriptor(\CatalogItem.name)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func addCatalogItem(name: String) async {
        context.insert(CatalogItem(name: name))
    }

    func seedCatalogIfNeeded() async {
        let descriptor = FetchDescriptor<CatalogItem>()
        let existing = (try? context.fetch(descriptor)) ?? []

        guard existing.isEmpty else { return }

        let starters = ["Milk", "Eggs", "Bread", "Butter", "Cheese"]

        starters.forEach {
            context.insert(CatalogItem(name: $0))
        }
    }
}
