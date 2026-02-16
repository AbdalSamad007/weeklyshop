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

    @StateObject private var session = AppSession()

    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environmentObject(session)
        }
        .modelContainer(for: [WeeklyItem.self, MasterItem.self, CatalogItem.self])
    }
}





