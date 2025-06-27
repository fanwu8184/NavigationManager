import SwiftUI

/// A view modifier that adds navigation capabilities to any view without embedding it in additional UI containers.
/// This allows the view to handle navigation presentations (sheets, full screen covers, alerts, etc.)
struct NavigationCapableContainer: ViewModifier {
    @Environment(NavigationManager.self) private var manager
    private let root: any NavigableScreen

    init(root: any NavigableScreen) {
        self.root = root
    }

    func body(content: Content) -> some View {
        content
            .modifier(NavigationPresentationModifier(manager: manager, root: root))
    }
}
