//
//  MasterListView.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import SwiftUI
import SwiftData

struct MasterListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \MasterItem.name) private var items: [MasterItem]

    @State private var newItemName = ""
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    Text(item.name)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Master List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                addItemSheet
            }
            .onAppear {
                seedMasterIfNeeded()
            }
        }
    }

    private var addItemSheet: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Item name", text: $newItemName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Add Item") { addItem() }
                    .buttonStyle(.borderedProminent)
                    .disabled(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
            .padding()
            .navigationTitle("New Master Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAddSheet = false
                        newItemName = ""
                    }
                }
            }
        }
    }

    private func addItem() {
        let trimmed = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        context.insert(MasterItem(name: trimmed))
        newItemName = ""
        showingAddSheet = false
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            context.delete(items[index])
        }
    }

    private func seedMasterIfNeeded() {
        guard items.isEmpty else { return }
        ["Milk", "Eggs", "Bread"].forEach { context.insert(MasterItem(name: $0)) }
    }
}



