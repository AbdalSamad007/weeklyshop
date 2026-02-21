//
//  ActivityRow.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 21/02/2026.
//

import SwiftUI

struct ActivityRow: View {
    let event: ActivityEvent

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)

            VStack(alignment: .leading) {
                Text(description)
                    .font(.body)

                Text(event.timestamp, style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var icon: String {
        switch event.type {
        case .addedItem:
            return "plus.circle.fill"

        case .deletedItem:
            return "trash.circle.fill"

        case .toggledItem:
            return "checkmark.circle.fill"

        case .ownershipTransferred:
            return "arrow.triangle.2.circlepath.circle.fill"

        case .joinedFamily:
            return "person.crop.circle.badge.plus"

        case .leftFamily:
            return "person.crop.circle.badge.minus"

        case .deletedFamily:
            return "xmark.octagon.fill"
        }
    }

    private var description: String {
        let name = displayName
        switch event.type {
            
        case .leftFamily:
            return "A member left the family"

        case .deletedFamily:
            return "Family was deleted"
            
        case .toggledItem:
            let item = event.metadata["itemName"] ?? "Item"
            let state = event.metadata["newValue"] ?? ""
            return "\(item) was \(state)"
            
        case .addedItem:
            return "\(name) added \(event.metadata["itemName"] ?? "an item")"
            
        case .deletedItem:
            return "\(name) removed \(event.metadata["itemName"] ?? "an item")"
            
        case .ownershipTransferred:
            return "\(name) transferred ownership"
            
        case .joinedFamily:
            return "\(name) joined the family"
            
        case .leftFamily:
            return "\(name) left the family"
            
        case .deletedFamily:
            return "\(name) deleted the family"
        }
    }
    
    private var displayName: String {
        event.userEmail
            .components(separatedBy: "@")
            .first?
            .capitalized ?? "Someone"
    }
}
