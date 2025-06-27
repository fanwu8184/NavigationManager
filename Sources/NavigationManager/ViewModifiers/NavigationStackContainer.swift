import SwiftUI

/// View modifier that wraps a view in a navigation stack.
struct NavigationStackContainer: ViewModifier {
    @Environment(NavigationManager.self) private var manager
    private let root: any NavigableScreen
    private let tint: Color?

    init(root: any NavigableScreen, tint: Color? = nil) {
        self.root = root
        self.tint = tint
    }

    func body(content: Content) -> some View {
        NavigationStack(
            path: Binding(
                get: { manager.stackPaths[root.id] ?? [] },
                set: { manager.stackPaths[root.id] = $0 }
            )
        ) {
            content
                .modifier(NavigationPresentationModifier(manager: manager, root: root))
        }
        .tint(tint)
    }
}
