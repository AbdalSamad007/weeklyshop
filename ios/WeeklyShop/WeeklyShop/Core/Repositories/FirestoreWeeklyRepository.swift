//
//  FirestoreWeeklyRepository.swift
//  WeeklyShop
//

import Foundation
import FirebaseFirestore

@MainActor
final class FirestoreWeeklyRepository: WeeklyRepository {

    private let db = Firestore.firestore()
    private let userId: String
    private let familyId: String?
    private let scope: ListScope
    private var listener: ListenerRegistration?
    private let authService: AuthService


    init(userId: String, familyId: String?, scope: ListScope, authService: AuthService) {
        self.userId = userId
        self.familyId = familyId
        self.scope = scope
        self.authService = authService
    }

    // MARK: - Collection reference

    private var collection: CollectionReference {
        switch scope {
        case .personal:
            return db.collection("users")
                .document(userId)
                .collection("personalWeeklyItems")

        case .family:
            guard let familyId else {
                fatalError("Family scope selected but familyId is nil")
            }

            return db.collection("families")
                .document(familyId)
                .collection("weeklyItems")
        }
    }


    // MARK: - Weekly

    func fetchWeeklyItems() async -> [WeeklyItem] {
        do {
            let snapshot = try await collection.getDocuments()

            return snapshot.documents.map { doc in
                let data = doc.data()

                return WeeklyItem(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    isChecked: data["isChecked"] as? Bool ?? false
                )
            }
        } catch {
            print("Error fetching weekly items:", error)
            return []
        }
    }
    
    func weeklyItemsStream() -> AsyncStream<[WeeklyItem]> {
        AsyncStream { continuation in

            // Ensure only one active listener
            listener?.remove()

            listener = collection
                .order(by: "createdAt")
                .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    continuation.yield([])
                    return
                }

                    let items = documents.map { doc in
                        let data = doc.data()
                        return WeeklyItem(
                            id: doc.documentID,
                            name: data["name"] as? String ?? "",
                            isChecked: data["isChecked"] as? Bool ?? false
                        )
                    }

                    // ✅ Smart sorting: unchecked first, checked last
                    let sortedItems = items.sorted { lhs, rhs in
                        if lhs.isChecked == rhs.isChecked {
                            return false // preserve Firestore createdAt order
                        }
                        return !lhs.isChecked && rhs.isChecked
                    }

                    continuation.yield(sortedItems)
            }

            continuation.onTermination = { [weak self] _ in
                Task { @MainActor in
                    self?.listener?.remove()
                    self?.listener = nil
                }
            }
        }
    }
    
    func stopListening() {
        listener?.remove()
    }

    func addItem(name: String) async {
        do {
            try await collection.addDocument(data: [
                "name": name,
                "isChecked": false,
                "createdAt": Timestamp()
            ])

            if scope == .family {
                await authService.logActivity(
                    type: .addedItem,
                    metadata: ["itemName": name]
                )
            }

        } catch {
            print("Error adding item:", error)
        }
    }


    func toggleItem(_ item: WeeklyItem) async {
        do {
            try await collection
                .document(item.id)
                .updateData([
                    "isChecked": !item.isChecked
                ])

            if scope == .family {
                await authService.logActivity(
                    type: .toggledItem,
                    metadata: [
                        "itemName": item.name,
                        "newValue": (!item.isChecked) ? "checked" : "unchecked"
                    ]
                )
            }

        } catch {
            print("Error toggling item:", error)
        }
    }

    func delete(_ item: WeeklyItem) async {
        do {
            try await collection.document(item.id).delete()

            if scope == .family {
                await authService.logActivity(
                    type: .deletedItem,
                    metadata: ["itemName": item.name]
                )
            }

        } catch {
            print("Error deleting item:", error)
        }
    }

    func delete(at offsets: IndexSet, from items: [WeeklyItem]) async {
        for index in offsets {
            let item = items[index]
            await delete(item)
        }
    }

    func resetWeek(masterItems: [MasterItem]) async {
        do {
            let snapshot = try await collection.getDocuments()

            for doc in snapshot.documents {
                try await doc.reference.delete()
            }

            for item in masterItems {
                try await collection.addDocument(data: [
                    "name": item.name,
                    "isChecked": false
                ])
            }
        } catch {
            print("Error resetting week:", error)
        }
    }

    // MARK: - Master (temporary stubs)

    func fetchMasterItems() async -> [MasterItem] {
        return []
    }

    func seedMasterIfNeeded() async {}

    // MARK: - Catalog (temporary stubs)

    func fetchCatalogItems() async -> [CatalogItem] {
        return []
    }

    func addCatalogItem(name: String) async {}

    func seedCatalogIfNeeded() async {}
}
