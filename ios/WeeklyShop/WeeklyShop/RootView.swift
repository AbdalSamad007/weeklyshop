//
//  RootView.swift
//  WeeklyShop
//

import SwiftUI
import FirebaseAuth

struct RootView: View {

    @EnvironmentObject var authService: AuthService
    @State private var selectedScope: ListScope = .personal

    var body: some View {
        Group {
            if let user = authService.user {

                VStack(spacing: 0) {

                    // Scope Picker
                    if authService.familyId != nil {
                        Picker("List Scope", selection: $selectedScope) {
                            Text("Family").tag(ListScope.family)
                            Text("Personal").tag(ListScope.personal)
                        }
                        .pickerStyle(.segmented)
                        .padding()
                    }

                    RootTabView(
                        repository: FirestoreWeeklyRepository(
                            userId: user.uid,
                            familyId: authService.familyId,
                            scope: selectedScope,
                            authService: authService
                        ),
                        scope: selectedScope
                    )
                    .id(selectedScope)

                }

            } else {
                AuthView()
            }
        }
        .onChange(of: authService.familyId) { newFamilyId in
            // Auto switch to family when user joins
            if newFamilyId != nil {
                selectedScope = .family
            } else {
                selectedScope = .personal
            }
        }
    }
}
