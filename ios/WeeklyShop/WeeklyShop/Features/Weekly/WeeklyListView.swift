//
//  WeeklyListView.swift
//  WeeklyShop
//  Phase 2 - Working in Progress
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import SwiftUI
import UIKit

struct WeeklyListView: View {
    
    @EnvironmentObject private var session: AppSession
    @StateObject private var viewModel: WeeklyListViewModel
    @EnvironmentObject var authService: AuthService
    
    private let deleteHaptic = UIImpactFeedbackGenerator(style: .medium)
    private let undoHaptic = UIImpactFeedbackGenerator(style: .light)
    private let toggleHaptic = UIImpactFeedbackGenerator(style: .light)

    init(repository: WeeklyRepository) {
        _viewModel = StateObject(
            wrappedValue: WeeklyListViewModel(repository: repository)
        )
    }

    var body: some View {
        NavigationStack {

            VStack(spacing: 4) {
                Text("DEBUG FAMILY ID")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(authService.familyId ?? "No family")
                    .font(.caption2)
                    .foregroundColor(.red)
            }

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
                                    toggleHaptic.impactOccurred()
                                    viewModel.toggleItem(item)
                                } label: {
                                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(item.isChecked ? .green : .gray)
                                        .scaleEffect(item.isChecked ? 1.1 : 1.0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: item.isChecked)
                                }
                                .buttonStyle(.plain)

                                Text(item.name)
                                    .strikethrough(item.isChecked)
                                    .foregroundStyle(item.isChecked ? .secondary : .primary)
                                    .opacity(item.isChecked ? 0.6 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: item.isChecked)
                            }
                        }
                        .onDelete { offsets in
                            deleteHaptic.impactOccurred()
                            viewModel.delete(at: offsets)
                        }
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
        .overlay(alignment: .bottom) {
            if let deleted = viewModel.recentlyDeletedItem {
                HStack(spacing: 16) {

                    Image(systemName: "trash")
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(Color.red)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Item Deleted")
                            .font(.subheadline.weight(.semibold))

                        Text(deleted.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        undoHaptic.impactOccurred()
                        viewModel.undoDelete()
                    } label: {
                        Text("Undo")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                .padding(.bottom, 20)
                .transition(
                    .move(edge: .bottom)
                    .combined(with: .opacity)
                )
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.85),
                    value: viewModel.recentlyDeletedItem != nil
                )
            }
        }    }

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


