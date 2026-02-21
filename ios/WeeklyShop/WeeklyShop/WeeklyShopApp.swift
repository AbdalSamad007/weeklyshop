//
//  WeeklyShopApp.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct WeeklyShopApp: App {

    @StateObject private var session = AppSession()
    @StateObject private var authService = AuthService()

    init() {
        FirebaseApp.configure()
        _authService = StateObject(wrappedValue: AuthService())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .environmentObject(authService)
        }
    }

}





