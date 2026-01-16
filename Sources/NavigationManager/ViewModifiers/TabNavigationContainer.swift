import SwiftUI

/// View modifier that wraps a view in a TabView for tab navigation.
struct TabNavigationContainer: ViewModifier {
  @Environment(NavigationManager.self) private var manager
  private let root: any NavigableScreen
  private let tabs: [any NavigableScreen]
  
  init(root: any NavigableScreen, tabs: [any NavigableScreen]) {
    self.root = root
    self.tabs = tabs
  }
  
  func body(content: Content) -> some View {
    TabView(
      selection: Binding(
        get: { manager.selectedTab[root.id] ?? tabs.first?.id ?? "" },
        set: { manager.selectedTab[root.id] = $0 }
      )
    ) {
      content
    }
  }
}
