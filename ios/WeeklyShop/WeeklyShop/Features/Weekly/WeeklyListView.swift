//
//  WeeklyListView.swift
//  WeeklyShop
//  Phase 2 - Working in Progress
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import SwiftUI
import SwiftData

struct WeeklyListView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \WeeklyItem.name) private var weeklyItems: [WeeklyItem]
    @Query(sort: \MasterItem.name) private var masterItems: [MasterItem]
    @Query(sort: \CatalogItem.name) private var catalogItems: [CatalogItem]

    @State private var newItemName: String = ""
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(weeklyItems) { item in
                    HStack(spacing: 12) {
                        Button {
                            item.isChecked.toggle()
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
                .onDelete(perform: deleteWeeklyItems)
            }
            .navigationTitle("WeeklyShop")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset Week") { resetWeek() }
                }
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
                seedCatalogIfNeeded()
                if weeklyItems.isEmpty {
                    resetWeek()
                }
            }
        }
    }

    private var addItemSheet: some View {
        NavigationStack {
            let query = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
            let lowerQuery = query.lowercased()

            let suggestions = catalogItems
                .map { $0.name }
                .filter { lowerQuery.isEmpty || $0.lowercased().contains(lowerQuery) }
                .prefix(30)

            List {
                Section {
                    TextField("Search item", text: $newItemName)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                }

                if !suggestions.isEmpty {
                    Section("Suggestions") {
                        ForEach(Array(suggestions), id: \.self) { suggestion in
                            Button(suggestion) {
                                addWeeklyItem(named: suggestion, alsoSaveToCatalog: false)
                            }
                        }
                    }
                }

                let existsInCatalog = catalogItems.contains { $0.name.lowercased() == lowerQuery }

                if !query.isEmpty && !existsInCatalog {
                    Section {
                        Button("Add \"\(query)\"") {
                            addWeeklyItem(named: query, alsoSaveToCatalog: true)
                        }
                    }
                }
            }
            .navigationTitle("Add Item")
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

    private func addWeeklyItem(named name: String, alsoSaveToCatalog: Bool) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // Optional: prevent duplicates in weekly list
        let alreadyInWeekly = weeklyItems.contains { $0.name.lowercased() == trimmed.lowercased() }
        if !alreadyInWeekly {
            context.insert(WeeklyItem(name: trimmed, isChecked: false))
        }

        if alsoSaveToCatalog {
            let alreadyInCatalog = catalogItems.contains { $0.name.lowercased() == trimmed.lowercased() }
            if !alreadyInCatalog {
                context.insert(CatalogItem(name: trimmed))
            }
        }

        newItemName = ""
        showingAddSheet = false
    }

    private func deleteWeeklyItems(at offsets: IndexSet) {
        for index in offsets {
            context.delete(weeklyItems[index])
        }
    }

    private func resetWeek() {
        // Delete all weekly items
        weeklyItems.forEach { context.delete($0) }

        // Recreate from Master list (persistent)
        for m in masterItems {
            context.insert(WeeklyItem(name: m.name, isChecked: false))
        }
    }

    private func seedCatalogIfNeeded() {
        guard catalogItems.isEmpty else { return }

        let starters = [
            // Dairy & Eggs
            "Milk", "Skimmed Milk", "Semi-Skimmed Milk", "Whole Milk",
            "Eggs", "Butter", "Cheese", "Cheddar", "Mozzarella",
            "Yogurt", "Greek Yogurt", "Cream", "Sour Cream",

            // Bread & Bakery
            "Bread", "Wholemeal Bread", "White Bread",
            "Bagels", "Wraps", "Pitta Bread",
            "Croissants", "Crumpets", "Muffins",

            // Fruit
            "Apples", "Bananas", "Oranges", "Grapes",
            "Strawberries", "Blueberries", "Pineapple",
            "Mango", "Peaches", "Pears", "Lemons", "Limes",

            // Vegetables
            "Potatoes", "Sweet Potatoes",
            "Onions", "Red Onions", "Garlic",
            "Carrots", "Broccoli", "Cauliflower",
            "Spinach", "Lettuce", "Cucumber",
            "Tomatoes", "Cherry Tomatoes",
            "Bell Peppers", "Chilli Peppers",
            "Courgette", "Aubergine", "Mushrooms",

            // Meat & Poultry
            "Chicken Breast", "Chicken Thighs",
            "Minced Beef", "Steak",
            "Lamb", "Turkey",
            "Bacon", "Sausages",

            // Fish
            "Salmon", "Tuna", "Cod",
            "Prawns", "Fish Fingers",

            // Grains & Carbs
            "Rice", "Brown Rice", "Basmati Rice",
            "Pasta", "Spaghetti", "Penne",
            "Noodles", "Couscous", "Quinoa",
            "Oats", "Cereal",

            // Tinned & Jarred
            "Baked Beans", "Chickpeas", "Kidney Beans",
            "Tinned Tomatoes", "Sweetcorn",
            "Tuna (Tinned)", "Soup",
            "Pasta Sauce", "Pesto",

            // Frozen
            "Frozen Peas", "Frozen Vegetables",
            "Frozen Chicken", "Frozen Pizza",
            "Ice Cream",

            // Snacks
            "Crisps", "Chocolate",
            "Biscuits", "Cookies",
            "Popcorn", "Nuts",

            // Breakfast & Spreads
            "Jam", "Honey",
            "Peanut Butter", "Chocolate Spread",

            // Drinks
            "Water", "Sparkling Water",
            "Orange Juice", "Apple Juice",
            "Soft Drinks",
            "Tea", "Coffee",

            // Baking
            "Flour", "Sugar",
            "Brown Sugar", "Icing Sugar",
            "Baking Powder",
            "Vanilla Extract",
            "Chocolate Chips",

            // Cooking Essentials
            "Olive Oil", "Vegetable Oil",
            "Salt", "Black Pepper",
            "Mixed Herbs", "Curry Powder",
            "Paprika", "Chilli Flakes",
            "Soy Sauce", "Vinegar",

            // Household
            "Toilet Paper", "Kitchen Roll",
            "Washing Up Liquid",
            "Laundry Detergent",
            "Fabric Softener",
            "Bin Bags",
            "Cleaning Spray",
            "Sponges",

            // Personal Care
            "Shampoo", "Conditioner",
            "Body Wash", "Soap",
            "Toothpaste", "Toothbrush",
            "Deodorant",
            "Razor Blades"
        ]

        starters.forEach { context.insert(CatalogItem(name: $0)) }
    }

}


