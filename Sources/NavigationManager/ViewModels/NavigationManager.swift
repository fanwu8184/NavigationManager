import SwiftUI

/// Manages navigation state and transitions between screens.
@MainActor
@Observable
public class NavigationManager {
    /// Tracks the selected tab for each root screen.
    var selectedTab: [String: String] = [:]
    /// Tracks the navigation stack paths for each root screen.
    var stackPaths: [String: [NavigationItem<AnyView>]] = [:]
    /// Tracks presented items (sheets or full-screen covers) for each root screen.
    var presentedItems: [String: NavigationItem<AnyView>] = [:]
    
    public init() {}

    /// Pushes a child screen onto the navigation stack from a root screen.
    public func push<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child) {
        let item = NavigationItem(view: AnyView(child.contentView()), mode: .stack)
        stackPaths[root.id, default: []].append(item)
    }
    
    /// Presents a child screen as a sheet from a root screen.
    public func presentSheet<Root: NavigableScreen, Child: NavigableScreen>(
        from root: Root,
        to child: Child,
        detents: Set<PresentationDetent> = [.large]
    ) {
        let item = NavigationItem(view: AnyView(child.contentView()), mode: .sheet(detents: detents))
        presentedItems[root.id] = item
    }
    
    /// Presents a child screen as a full-screen cover from a root screen.
    public func presentFullScreen<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child) {
        let item = NavigationItem(view: AnyView(child.contentView()), mode: .fullScreen)
        presentedItems[root.id] = item
    }

    /// Dismisses a presented sheet or full-screen cover from the root screen.
    public func dismiss<Root: NavigableScreen>(from root: Root) {
        presentedItems[root.id] = nil
    }

    /// Pops the top view from the navigation stack for the root screen.
    public func pop<Root: NavigableScreen>(from root: Root) {
        stackPaths[root.id]?.removeLast()
    }

    /// Clears the navigation stack for the root screen, returning to the root view.
    public func popToRoot<Root: NavigableScreen>(from root: Root) {
        stackPaths[root.id]?.removeAll()
    }
    
    /// Selects a child screen as a tab from a root screen.
    public func selectTab<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child) {
        selectedTab[root.id] = child.id
    }
    
    /// Returns the ID of the currently selected tab for the given root screen, if any.
    public func selectedTabID<Root: NavigableScreen>(for root: Root) -> String? {
        selectedTab[root.id]
    }
    
    /// Resets all navigation state, clearing selected tabs, navigation stacks, and presented screens.
    public func reset() {
        selectedTab.removeAll()
        stackPaths.removeAll()
        presentedItems.removeAll()
    }
}
