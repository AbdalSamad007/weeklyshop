//
//  SwiftDataModels.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 12/02/2026.
//

import Foundation
import SwiftData

@Model
final class MasterItem {
    var id: UUID
    var name: String

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

@Model
final class WeeklyItem {
    var id: UUID
    var name: String
    var isChecked: Bool

    init(name: String, isChecked: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isChecked = isChecked
    }
}

@Model
final class CatalogItem {
    var id: UUID
    var name: String

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

