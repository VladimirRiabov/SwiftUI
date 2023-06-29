import SwiftUI

struct MainView<MainRouter: Router>: View where MainRouter.Route == MainRoute {
    let router: MainRouter
    @Binding var selectedTab: TabBarRoute
    @State private var showingLogin = false

    var body: some View {
        NavigationView {
            VStack {
                router.viewFor(route: .loginView(data: "Login"), selectedTab: $selectedTab) {
                    Text("Переход на логин")
                }
                Button {
                    selectedTab = .profile
                } label: {
                    Text("Переход на профайл")
                }
            }
            .navigationBarItems(trailing: Button(action: { showingLogin.toggle() }) {
                Image(systemName: "person")
            })
            .sheet(isPresented: $showingLogin) {
                LoginView(text: "Login")
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            router: MainRouter(),
            selectedTab: Binding(
                get: { TabBarRoute.main },
                set: { _ in }
            )
        )
    }
}




