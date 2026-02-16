//
//  WeeklyRepository.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 16/02/2026.
//

import Foundation

protocol WeeklyRepository {
    func fetchWeeklyItems() -> [WeeklyItem]
    func addItem(name: String)
    func toggleItem(_ item: WeeklyItem)
    func delete(_ item: WeeklyItem)
    func delete(at offsets: IndexSet, from items: [WeeklyItem])
    func resetWeek(masterItems: [MasterItem])
}



