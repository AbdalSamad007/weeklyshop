//
//  SettingsView.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {

                Section("Weekly Cycle") {
                    Text("Your weekly list is generated from your master list.")
                    Text("Use 'Reset Week' in the Weekly tab to regenerate the list.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("App Info") {
                    Text("Version 0.2")
                    Text("Phase 2 – MVP Complete")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

            }
            .navigationTitle("Settings")
        }
    }
}


