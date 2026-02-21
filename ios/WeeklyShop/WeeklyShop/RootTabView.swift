import SwiftUI

struct RootTabView: View {

    let repository: WeeklyRepository
    let scope: ListScope

    var body: some View {

        TabView {

            WeeklyListView(repository: repository)
                .tabItem {
                    Label("Weekly", systemImage: "cart")
                }

            if scope == .family {
                MasterListView()
                    .tabItem {
                        Label("Master", systemImage: "list.bullet")
                    }
            }
            
            if scope == .family {
                ActivityView()
                    .tabItem {
                        Label("Activity", systemImage: "clock.arrow.circlepath")
                    }
            }

            SettingsView(scope: scope)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

