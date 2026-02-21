//
//  ActivityEvent.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 21/02/2026.
//

import Foundation

struct ActivityEvent: Identifiable {
    let id: String
    let type: ActivityType
    let userId: String
    let userEmail: String
    let metadata: [String: String]
    let timestamp: Date
}

enum ActivityType: String {
    case addedItem = "added_item"
    case deletedItem = "deleted_item"
    case ownershipTransferred = "ownership_transferred"
    case joinedFamily = "joined_family"
    case leftFamily = "left_family"
    case deletedFamily = "deleted_family"
    case toggledItem   // ← ADD THIS
}
