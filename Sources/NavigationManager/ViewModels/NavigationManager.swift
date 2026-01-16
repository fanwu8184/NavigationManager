import SwiftUI

/// Manages navigation state and transitions between screens.
@MainActor
@Observable
public class NavigationManager: NavigationManagerProtocol {
  /// Tracks the selected tab for each root screen.
  var selectedTab: [String: String] = [:]
  /// Tracks the navigation stack paths for each root screen.
  var stackPaths: [String: [NavigationItem]] = [:]
  /// Tracks presented items (sheets or full-screen covers) for each root screen.
  var presentedItems: [String: NavigationItem] = [:]
  /// Tracks presented alerts for each root screen.
  var alertItems: [String: NavigationAlert] = [:]

  public init() {}

  /// Pushes a child screen onto the navigation stack from a root screen.
  public func push<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child) {
    let item = NavigationItem(id: child.id, makeView: { child.contentView() }, mode: .stack)
    stackPaths[root.id, default: []].append(item)
  }

  /// Pushes a sequence of screens onto the navigation stack, using the first screen as the root.
  public func push(screens: [any NavigableScreen]) {
    guard screens.count > 1 else { return }
    let root = screens[0]
    resetStacks(in: root)
    for screen in screens.dropFirst() {
      let item = NavigationItem(id: screen.id, makeView: { AnyView(screen.contentView()) }, mode: .stack)
      stackPaths[root.id, default: []].append(item)
    }
  }

  /// Presents a child screen as a sheet from a root screen.
  public func presentSheet<Root: NavigableScreen, Child: NavigableScreen>(
    from root: Root,
    to child: Child,
    detents: Set<PresentationDetent> = [.large],
    isScalable: Bool = false
  ) {
    let item = NavigationItem(id: child.id, makeView: { child.contentView() }, mode: .sheet(detents: detents, isScalable: isScalable))
    presentedItems[root.id] = item
  }

  /// Presents a child screen as a full-screen cover from a root screen.
  public func presentFullScreen<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child) {
    let item = NavigationItem(id: child.id, makeView: { child.contentView() }, mode: .fullScreen)
    presentedItems[root.id] = item
  }

  /// Presents an alert from a root screen.
  public func presentAlert<Root: NavigableScreen, A: View, M: View>(
    from root: Root,
    title: String,
    @ViewBuilder actions: @escaping () -> A,
    @ViewBuilder message: @escaping () -> M
  ) {
    let alert = NavigationAlert(title: title, actions: actions, message: message)
    alertItems[root.id] = alert
  }

  /// Presents an alert from a root screen without a message.
  public func presentAlert<Root: NavigableScreen, A: View>(
    from root: Root,
    title: String,
    @ViewBuilder actions: @escaping () -> A
  ) {
    let alert = NavigationAlert(title: title, actions: actions)
    alertItems[root.id] = alert
  }

  /// Dismisses a presented sheet or full-screen cover from the root screen.
  public func dismiss<Root: NavigableScreen>(from root: Root) {
    presentedItems[root.id] = nil
  }

  /// Dismisses the alert presented on the root screen.
  public func dismissAlert<Root: NavigableScreen>(from root: Root) {
    alertItems[root.id] = nil
  }

  /// Pops the top view from the navigation stack for the root screen.
  public func pop<Root: NavigableScreen>(from root: Root) {
    if var stack = stackPaths[root.id], !stack.isEmpty {
      stack.removeLast()
      stackPaths[root.id] = stack
    }
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
  public func getSelectedTabID<Root: NavigableScreen>(for root: Root) -> String? {
    selectedTab[root.id]
  }

  /// Resets all navigation state, clearing selected tabs, navigation stacks, and presented screens.
  public func reset() {
    selectedTab.removeAll()
    stackPaths.removeAll()
    presentedItems.removeAll()
    alertItems.removeAll()
  }

  public func resetStacks<Root: NavigableScreen>(in root: Root) {
    stackPaths[root.id] = []
  }
}
