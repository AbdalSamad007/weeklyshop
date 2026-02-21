//
//  TransferOwnershipView.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 20/02/2026.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TransferOwnershipView: View {

    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss

    @State private var members: [String] = []
    @State private var selectedMember: String?

    var body: some View {
        List {
            ForEach(members, id: \.self) { memberId in
                Button {
                    selectedMember = memberId
                } label: {
                    HStack {
                        Text(memberId)
                        Spacer()
                        if selectedMember == memberId {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .navigationTitle("Transfer Ownership")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Transfer") {
                    if let selectedMember {
                        Task {
                            try? await authService.transferOwnership(to: selectedMember)
                            dismiss()
                        }
                    }
                }
                .disabled(selectedMember == nil)
            }
        }
        .onAppear {
            loadMembers()
        }
    }

    private func loadMembers() {
        guard let familyId = authService.familyId else { return }

        Firestore.firestore()
            .collection("families")
            .document(familyId)
            .getDocument { snapshot, _ in
                if let data = snapshot?.data(),
                   let membersArray = data["members"] as? [String],
                   let currentUid = authService.user?.uid {

                    // Remove current owner from selection
                    members = membersArray.filter { $0 != currentUid }
                }
            }
    }
}
