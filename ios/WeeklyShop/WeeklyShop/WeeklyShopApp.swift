//
//  WeeklyShopApp.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import SwiftUI
import SwiftData

@main
struct WeeklyShopApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: [MasterItem.self, WeeklyItem.self, CatalogItem.self])
    }
}


