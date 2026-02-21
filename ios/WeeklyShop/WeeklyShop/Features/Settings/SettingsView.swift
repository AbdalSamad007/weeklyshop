//
//  SettingsView.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 11/02/2026.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var authService: AuthService
    @State private var inviteCodeInput = ""
    @State private var showingDeleteConfirmation = false
    
    let scope: ListScope

    var body: some View {
        NavigationStack {
            Form {

                // MARK: - Family Scope
                if scope == .family {

                    Section("Family") {

                        // Only owner can generate new code
                        if authService.isFamilyOwner {
                            Button("Generate Invite Code") {
                                Task {
                                     await authService.generateFamilyInviteCode()
                                }
                            }
                        }
                        
                        if authService.isFamilyOwner {
                            NavigationLink("Transfer Ownership") {
                                TransferOwnershipView()
                                    .environmentObject(authService)
                            }
                        }
                        
                        if authService.isFamilyOwner {

                            Button("Delete Family", role: .destructive) {
                                showingDeleteConfirmation = true
                            }
                        }

                        if let inviteCode = authService.currentInviteCode {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(authService.isFamilyOwner
                                     ? "Current Invite Code"
                                     : "Invite Code (Owner Managed)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                Text(inviteCode)
                                    .font(.title3)
                                    .bold()
                                    .textSelection(.enabled)
                            }
                        }
                        
                        if !authService.isFamilyOwner {
                            Button("Leave Family", role: .destructive) {
                                Task {
                                     await authService.leaveFamily()
                                }
                            }
                        }
                        
                    }
                }
    

                // MARK: - Personal Scope (Join Family)
                if scope == .personal {

                    Section("Family") {

                        // Join
                        TextField("Enter Invite Code", text: $inviteCodeInput)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        Button("Join Family") {
                            Task {
                                await authService.joinFamily(with: inviteCodeInput)
                                inviteCodeInput = ""
                            }
                        }
                        .disabled(inviteCodeInput.trimmingCharacters(in: .whitespaces).isEmpty)

                        Divider()

                        // Create
                        Button("Create Family") {
                            Task {
                                 await authService.createFamily()
                            }
                        }
                    }
                }

                // MARK: - Weekly Info
                Section("Weekly Cycle") {
                    Text("Your weekly list is generated from your master list.")
                    Text("Use 'Reset Week' in the Weekly tab to regenerate the list.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // MARK: - App Info
                Section("App Info") {
                    Text("Version 0.3")
                    Text("Phase 3 – Family Sharing In Progress")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // MARK: - Sign Out
                Button("Sign Out") {
                    try? authService.signOut()
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Settings")
            .confirmationDialog(
                "Are you sure? This cannot be undone.",
                isPresented: $showingDeleteConfirmation
            ) {
                Button("Delete Family", role: .destructive) {
                    Task {
                         await authService.deleteFamily()
                    }
                }
            }
        }
        .alert("Error",
               isPresented: Binding(
                get: { authService.joinError != nil },
                set: { _ in authService.joinError = nil })
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authService.joinError ?? "")
        }
    }
}
