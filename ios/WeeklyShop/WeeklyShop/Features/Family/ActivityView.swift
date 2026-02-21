//
//  ActivityView.swift
//  WeeklyShop
//

import SwiftUI
import FirebaseFirestore

struct ActivityView: View {

    @EnvironmentObject var authService: AuthService
    @State private var events: [ActivityEvent] = []

    var body: some View {
        List {
            if events.isEmpty {
                ContentUnavailableView(
                    "No Activity Yet",
                    systemImage: "clock.arrow.circlepath",
                    description: Text("Family actions will appear here.")
                )
            } else {
                ForEach(groupedByDay.keys.sorted(by: >), id: \.self) { date in
                    Section(
                        header: Text(
                            date.formatted(date: .abbreviated, time: .omitted)
                        )
                    ) {
                        ForEach(groupedByDay[date] ?? []) { event in
                            ActivityRow(event: event)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped) // ✅ Premium grouped style
        .navigationTitle("Activity")
        .onAppear {
            listenForActivity()
        }
    }

    // MARK: - Grouping

    private var groupedByDay: [Date: [ActivityEvent]] {
        Dictionary(grouping: events) {
            Calendar.current.startOfDay(for: $0.timestamp)
        }
    }

    // MARK: - Firestore Listener

    private func listenForActivity() {
        guard let familyId = authService.familyId else { return }

        Firestore.firestore()
            .collection("families")
            .document(familyId)
            .collection("activity")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    print("❌ Activity listener error:", error)
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let decodedEvents: [ActivityEvent] = documents.compactMap { doc in
                    let data = doc.data()

                    guard let typeRaw = data["type"] as? String,
                          let type = ActivityType(rawValue: typeRaw),
                          let userId = data["userId"] as? String,
                          let email = data["userEmail"] as? String
                    else { return nil }

                    let timestamp =
                        (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()

                    return ActivityEvent(
                        id: doc.documentID,
                        type: type,
                        userId: userId,
                        userEmail: email,
                        metadata: data["metadata"] as? [String: String] ?? [:],
                        timestamp: timestamp
                    )
                }

                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        self.events = decodedEvents
                    }
                }
            }
    }
}
