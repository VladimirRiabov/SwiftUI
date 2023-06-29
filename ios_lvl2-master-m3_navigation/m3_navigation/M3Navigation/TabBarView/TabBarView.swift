import SwiftUI

struct TabBarView<TabBarRouter: Router>: View where TabBarRouter.Route == TabBarRoute {
    let router: TabBarRouter
    @State var selectedTab = TabBarRoute.main
    var body: some View {
        TabView(selection: $selectedTab) {
            router.viewFor(route: .main, selectedTab: $selectedTab) {
                EmptyView()
            }
            .tabItem {
                Label("Main", systemImage: "list.dash")
            }
            .tag(TabBarRoute.main)
            router.viewFor(route: .catalog, selectedTab: $selectedTab) {
                EmptyView()
            }
            .tabItem {
                Label("Catalog", systemImage: "books.vertical")
            }
            .tag(TabBarRoute.catalog)
            router.viewFor(route: .profile, selectedTab: $selectedTab) {
                EmptyView()
            }
            .tabItem {
                Label("Profile", systemImage: "square.and.pencil")
            }
            .tag(TabBarRoute.profile)
           
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(router: TabBarRouter())
    }
}
