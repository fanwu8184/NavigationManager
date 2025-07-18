import SwiftUI

@MainActor
public protocol NavigationManagerProtocol {
    func push<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child)
    func push(screens: [any NavigableScreen])
    func presentSheet<Root: NavigableScreen, Child: NavigableScreen>(
        from root: Root,
        to child: Child,
        detents: Set<PresentationDetent>
    )
    func presentFullScreen<Root: NavigableScreen, Child: NavigableScreen>(from root: Root, to child: Child)
    func dismiss<Root: NavigableScreen>(from root: Root)
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
        detents: Set<PresentationDetent> = [.large]
    ) {
        presentSheet(from: root, to: child, detents: detents)
    }
}
