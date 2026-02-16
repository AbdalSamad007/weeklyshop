//
//  MainAppView.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 16/02/2026.
//

import SwiftUI
import SwiftData

struct MainAppView: View {

    @Environment(\.modelContext) private var context

    var body: some View {

        let repository = SwiftDataWeeklyRepository(context: context)

        TabView {

            WeeklyListView(repository: repository)
                .tabItem {
                    Label("Weekly", systemImage: "cart")
                }

            MasterListView()
                .tabItem {
                    Label("Master", systemImage: "list.bullet")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

