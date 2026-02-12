//
//  ShoppingItem.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import Foundation

struct ShoppingItem: Identifiable {
    let id: UUID
    var name: String
    var isChecked: Bool
    var isRecurring: Bool

    init(id: UUID = UUID(), name: String, isChecked: Bool = false, isRecurring: Bool = false) {
        self.id = id
        self.name = name
        self.isChecked = isChecked
        self.isRecurring = isRecurring
    }
}
