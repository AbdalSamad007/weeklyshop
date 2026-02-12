//
//  RootTabView.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            WeeklyListView()
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
