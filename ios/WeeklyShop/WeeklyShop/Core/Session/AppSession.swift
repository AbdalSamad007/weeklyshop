//
//  AppSession.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 16/02/2026.
//

import Foundation
import Combine

@MainActor
final class AppSession: ObservableObject {

    @Published var currentUserId: String?
    @Published var familyId: String?
    @Published var role: UserRole = .member
    @Published var selectedListType: ListType = .personal
}

enum UserRole {
    case parent
    case member
}

enum ListType {
    case personal
    case family
}


