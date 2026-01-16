import SwiftUI

@MainActor
public protocol NavigationManagerProtocol {
  func push<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child)
  func push(screens: [any NavigableScreen])
  func presentSheet<Root: NavigableScreen, Child: NavigableScreen>(
    from root: Root,
    to child: Child,
    detents: Set<PresentationDetent>,
    isScalable: Bool
  )
  func presentFullScreen<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child)
  func presentAlert<Root: NavigableScreen, A: View, M: View>(
    from root: Root,
    title: String,
    @ViewBuilder actions: @escaping () -> A,
    @ViewBuilder message: @escaping () -> M
  )
  func presentAlert<Root: NavigableScreen, A: View>(
    from root: Root,
    title: String,
    @ViewBuilder actions: @escaping () -> A
  )
  func dismiss<Root: NavigableScreen>(from root: Root)
  func dismissAlert<Root: NavigableScreen>(from root: Root)
  func pop<Root: NavigableScreen>(from root: Root)
  func popToRoot<Root: NavigableScreen>(from root: Root)
  func selectTab<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child)
  func getSelectedTabID<Root: NavigableScreen>(for root: Root) -> String?
  func reset()
  func resetStacks<Root: NavigableScreen>(in root: Root)
}

public extension NavigationManagerProtocol {
  func presentSheet<Root: NavigableScreen, Child: NavigableScreen>(
    from root: Root,
    to child: Child,
    detents: Set<PresentationDetent> = [.large],
    isScalable: Bool = false
  ) {
    presentSheet(from: root, to: child, detents: detents, isScalable: isScalable)
  }
}
