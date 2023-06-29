//
//  TabBarRouter.swift
//  M3Navigation
//
//  Created by Владимир on 29.06.23.
//

import SwiftUI

enum TabBarRoute {
    case main
    case catalog
    case profile
}

struct TabBarRouter: Router {
    
    typealias Route = TabBarRoute
    
    func viewFor<T>(route: TabBarRoute, selectedTab: Binding<TabBarRoute>, content: () -> T) -> AnyView where T : View {
        switch route {
        case .catalog:
            return AnyView(CatalogView(text: "Catalog"))
        case .profile:
            return AnyView(ProfileView())
        case .main:
            return AnyView(MainView(router: MainRouter(), selectedTab: selectedTab))
            
        }
    }
}
