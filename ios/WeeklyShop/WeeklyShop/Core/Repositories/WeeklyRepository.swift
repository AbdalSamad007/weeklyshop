//
//  WeeklyRepository.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 16/02/2026.
//

import Foundation

@MainActor

protocol WeeklyRepository {

    // Weekly
    func fetchWeeklyItems() async -> [WeeklyItem]
    func addItem(name: String) async
    func toggleItem(_ item: WeeklyItem) async
    func delete(_ item: WeeklyItem) async
    func delete(at offsets: IndexSet, from items: [WeeklyItem]) async
    func resetWeek(masterItems: [MasterItem]) async

    // Master
    func fetchMasterItems() async -> [MasterItem]
    func seedMasterIfNeeded() async

    // Catalog
    func fetchCatalogItems() async -> [CatalogItem]
    func addCatalogItem(name: String) async
    func seedCatalogIfNeeded() async
}




