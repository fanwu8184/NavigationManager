import SwiftUI

public extension View {
    /// Embeds the view in a navigation stack with navigation capabilities.
    func withNavigationStack(root: any NavigableScreen) -> some View {
        modifier(NavigationStackContainer(root: root))
    }
    
    /// Embeds the view in a TabView with selection binding. Users must provide tab content (e.g., via ForEach) matching the tabs array.
    func withTabNavigation(root: any NavigableScreen, tabs: [any NavigableScreen]) -> some View {
        modifier(TabNavigationContainer(root: root, tabs: tabs))
    }
}
