//
//  AuthService.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 17/02/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class AuthService: ObservableObject {

    // MARK: - Published State

    @Published var user: User?
    @Published var familyId: String?
    @Published var currentInviteCode: String?
    @Published var joinError: String?
    @Published var joinSuccess: Bool = false
    @Published var isFamilyOwner: Bool = false
    @Published var isLoading: Bool = false
    @Published var globalError: String?

    // MARK: - Private Properties

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    private var authListener: AuthStateDidChangeListenerHandle?
    private var userListener: ListenerRegistration?
    private var familyListener: ListenerRegistration?

    // MARK: - Init

    init() {
        listenToAuthState()
    }

    // MARK: - Auth

    func signUp(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        try await createUserDocument(uid: result.user.uid, email: email)
    }

    func signIn(email: String, password: String) async throws {
        _ = try await auth.signIn(withEmail: email, password: password)
    }

    func signOut() throws {
        try auth.signOut()

        user = nil
        familyId = nil
        currentInviteCode = nil

        userListener?.remove()
        familyListener?.remove()

        userListener = nil
        familyListener = nil
    }

    // MARK: - Reactive Auth State

    private func listenToAuthState() {
        authListener = auth.addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            self.user = user

            guard let uid = user?.uid else {
                self.familyId = nil
                self.userListener?.remove()
                self.familyListener?.remove()
                self.userListener = nil
                self.familyListener = nil
                return
            }

            self.listenToUserDocument(uid: uid)
        }
    }

    // MARK: - User Document Listener (Reactive)

    private func listenToUserDocument(uid: String) {
        userListener?.remove()

        userListener = db.collection("users")
            .document(uid)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let data = snapshot?.data() else { return }

                if let familyId = data["familyId"] as? String, !familyId.isEmpty {
                    self?.familyId = familyId
                    self?.listenForFamilyInviteCode()
                } else {
                    self?.familyId = nil
                    self?.familyListener?.remove()
                    self?.currentInviteCode = nil
                }
            }
    }

    // MARK: - Family Invite Listener

    private func listenForFamilyInviteCode() {
        guard let familyId = familyId,
              let uid = auth.currentUser?.uid else { return }

        familyListener?.remove()

        familyListener = db.collection("families")
            .document(familyId)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let data = snapshot?.data() else { return }

                self?.currentInviteCode = data["inviteCode"] as? String

                let ownerId = data["ownerId"] as? String
                self?.isFamilyOwner = (ownerId == uid)
            }
    }


    // MARK: - Create Initial User + Family

    private func createUserDocument(uid: String, email: String) async throws {

        let userData: [String: Any] = [
            "email": email,
            "createdAt": Timestamp(date: Date())
        ]

        try await db.collection("users").document(uid).setData(userData)
    }


    // MARK: - Join Family

    func joinFamily(with inviteCode: String) async {
        guard let uid = auth.currentUser?.uid else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let query = try await db.collection("families")
                .whereField("inviteCode", isEqualTo: inviteCode)
                .getDocuments()

            guard let familyDoc = query.documents.first else {
                throw NSError(
                    domain: "",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid invite code"]
                )
            }

            let familyId = familyDoc.documentID

            try await db.collection("families")
                .document(familyId)
                .updateData([
                    "members": FieldValue.arrayUnion([uid])
                ])

            try await db.collection("users")
                .document(uid)
                .setData([
                    "familyId": familyId
                ], merge: true)

        } catch {
            globalError = error.localizedDescription
        }
    }

    // MARK: - Invite Code Generation

    func generateInviteCode() -> String {
        let letters = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        return String((0..<6).compactMap { _ in letters.randomElement() })
    }

    func generateFamilyInviteCode() async {
        guard let familyId = familyId else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let code = generateInviteCode()

            try await db.collection("families")
                .document(familyId)
                .updateData([
                    "inviteCode": code
                ])
        } catch {
            globalError = error.localizedDescription
        }
    }
    
    func createFamily(named name: String = "My Household") async {
        guard let uid = auth.currentUser?.uid else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let familyRef = db.collection("families").document()
            let newFamilyId = familyRef.documentID

            let familyData: [String: Any] = [
                "name": name,
                "ownerId": uid,
                "members": [uid],
                "createdAt": Timestamp(date: Date())
            ]

            try await familyRef.setData(familyData)

            try await db.collection("users")
                .document(uid)
                .setData(["familyId": newFamilyId], merge: true)
            await logActivity(type: .joinedFamily)

        } catch {
            globalError = error.localizedDescription
        }
    }
    
    func transferOwnership(to newOwnerId: String) async {
        guard let familyId = familyId,
              let currentUid = auth.currentUser?.uid else { return }

        guard isFamilyOwner else {
            globalError = "Only the owner can transfer ownership."
            return
        }

        guard newOwnerId != currentUid else {
            globalError = "You are already the owner."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await db.collection("families")
                .document(familyId)
                .updateData([
                    "ownerId": newOwnerId
                ])
            await logActivity(
                type: .ownershipTransferred,
                metadata: ["newOwnerId": newOwnerId]
            )
        } catch {
            globalError = error.localizedDescription
        }
    }
    
    func leaveFamily() async {
        guard let uid = auth.currentUser?.uid,
              let familyId = familyId else { return }

        guard !isFamilyOwner else {
            globalError = "Owner must transfer ownership before leaving."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await db.collection("families")
                .document(familyId)
                .updateData([
                    "members": FieldValue.arrayRemove([uid])
                ])

            try await db.collection("users")
                .document(uid)
                .updateData([
                    "familyId": FieldValue.delete()
                ])
            await logActivity(type: .leftFamily)

        } catch {
            globalError = error.localizedDescription
        }
    }
    
    func logActivity(
        type: ActivityType,
        metadata: [String: String] = [:]
    ) async {
        
        print("🔥 Attempting to log:", type.rawValue)
        
        guard let familyId = familyId,
              let uid = auth.currentUser?.uid,
              let email = auth.currentUser?.email else {
            print("❌ Missing familyId or user info")
            return
        }
        

        do {
            try await db.collection("families")
                .document(familyId)
                .collection("activity")
                .addDocument(data: [
                    "type": type.rawValue,
                    "userId": uid,
                    "userEmail": email,
                    "metadata": metadata,
                    "timestamp": FieldValue.serverTimestamp()
                ])
            print("✅ Activity logged")
        } catch {
            print("Activity log error:", error)
        }
    }
    
    func deleteFamily() async {
        guard let familyId = familyId,
              let currentUid = auth.currentUser?.uid else { return }

        guard isFamilyOwner else {
            globalError = "Only the owner can delete the family."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let familyRef = db.collection("families").document(familyId)
            let snapshot = try await familyRef.getDocument()

            guard let data = snapshot.data(),
                  let members = data["members"] as? [String] else { return }

            for memberId in members {
                try await db.collection("users")
                    .document(memberId)
                    .updateData([
                        "familyId": FieldValue.delete()
                    ])
            }
            await logActivity(type: .deletedFamily)
            try await familyRef.delete()

        } catch {
            globalError = error.localizedDescription
        }
    }}
