import SwiftUI

protocol Router {
  associatedtype Route
  func viewFor<T: View>(route: Route, selectedTab: Binding<TabBarRoute>, content: () -> T) -> AnyView
}
