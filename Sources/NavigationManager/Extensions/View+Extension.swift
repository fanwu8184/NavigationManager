import SwiftUI

public extension View {
    /// Adds navigation capabilities to the view without embedding in additional containers.
    func withNavigationCapabilities(root: any NavigableScreen) -> some View {
        modifier(NavigationCapableContainer(root: root))
    }

    /// Embeds the view in a navigation stack with navigation capabilities.
    func managedNavigationStack(root: any NavigableScreen, tint: Color? = nil) -> some View {
        modifier(NavigationStackContainer(root: root, tint: tint))
    }

    /// Embeds the view in a TabView with selection binding. Users must provide tab content (e.g., via ForEach) matching the tabs array.
    func managedTabNavigation(root: any NavigableScreen, tabs: [any NavigableScreen]) -> some View {
        modifier(TabNavigationContainer(root: root, tabs: tabs))
    }
}
