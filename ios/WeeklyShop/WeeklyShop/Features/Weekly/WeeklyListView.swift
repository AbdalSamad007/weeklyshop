//
//  WeeklyListView.swift
//  WeeklyShop
//  Phase 2 - Working in Progress
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import SwiftUI

struct WeeklyListView: View {
    
    @EnvironmentObject private var session: AppSession
    @StateObject private var viewModel: WeeklyListViewModel

    init(repository: WeeklyRepository) {
        _viewModel = StateObject(
            wrappedValue: WeeklyListViewModel(repository: repository)
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.weeklyItems.isEmpty {
                    ContentUnavailableView(
                        "No items this week",
                        systemImage: "cart",
                        description: Text("Add items from your master list to get started.")
                    )
                } else {
                    List {
                        ForEach(viewModel.weeklyItems) { item in
                            HStack(spacing: 12) {
                                Button {
                                    viewModel.toggleItem(item)
                                } label: {
                                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(item.isChecked ? .green : .gray)
                                }
                                .buttonStyle(.plain)

                                Text(item.name)
                                    .strikethrough(item.isChecked)
                                    .foregroundStyle(item.isChecked ? .secondary : .primary)
                            }
                        }
                        .onDelete { viewModel.delete(at: $0) }
                    }
                }
            }
            .navigationTitle("WeeklyShop")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset Week") {
                        viewModel.resetWeek()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddSheet) {
                addItemSheet
            }
            
        }
    }

    private var addItemSheet: some View {
        NavigationStack {

            let query = viewModel.newItemName
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let lowerQuery = query.lowercased()

            let suggestions = viewModel.catalogItems
                .map { $0.name }
                .filter { lowerQuery.isEmpty || $0.lowercased().contains(lowerQuery) }
                .prefix(30)

            List {
                Section {
                    TextField("Search item", text: $viewModel.newItemName)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                }

                if !suggestions.isEmpty {
                    Section("Suggestions") {
                        ForEach(Array(suggestions), id: \.self) { suggestion in
                            Button(suggestion) {
                                viewModel.addWeeklyItem(named: suggestion)
                            }
                        }
                    }
                }

                let existsInCatalog = viewModel.catalogItems.contains {
                    $0.name.lowercased() == lowerQuery
                }

                if !query.isEmpty && !existsInCatalog {
                    Section {
                        Button("Add \"\(query)\"") {
                            viewModel.addWeeklyItem(named: query, alsoSaveToCatalog: true)
                        }
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.showingAddSheet = false
                        viewModel.newItemName = ""
                    }
                }
            }
        }
    }
}



