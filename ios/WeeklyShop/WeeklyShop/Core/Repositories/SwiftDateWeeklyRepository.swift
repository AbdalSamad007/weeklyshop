//
//  SwiftDateWeeklyRepository.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 16/02/2026.
//

import SwiftData
import Foundation

final class SwiftDataWeeklyRepository: WeeklyRepository {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchWeeklyItems() -> [WeeklyItem] {
        let descriptor = FetchDescriptor<WeeklyItem>(
            sortBy: [SortDescriptor(\WeeklyItem.name)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func addItem(name: String) {
        context.insert(WeeklyItem(name: name, isChecked: false))
    }

    func toggleItem(_ item: WeeklyItem) {
        item.isChecked.toggle()
    }

    func delete(_ item: WeeklyItem) {
        context.delete(item)
    }

    func delete(at offsets: IndexSet, from items: [WeeklyItem]) {
        for index in offsets {
            context.delete(items[index])
        }
    }

    func resetWeek(masterItems: [MasterItem]) {
        let descriptor = FetchDescriptor<WeeklyItem>()
        let existing = (try? context.fetch(descriptor)) ?? []

        existing.forEach { context.delete($0) }

        masterItems.forEach {
            context.insert(WeeklyItem(name: $0.name, isChecked: false))
        }
    }
}

