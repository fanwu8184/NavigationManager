import SwiftUI

/// View modifier that handles sheet and full-screen presentations.
struct NavigationPresentationModifier: ViewModifier {
    private var manager: NavigationManager
    private let root: any NavigableScreen
    private let includingNavigationDestination: Bool

    init(
        manager: NavigationManager,
        root: any NavigableScreen,
        includingNavigationDestination: Bool = true
    ) {
        self.manager = manager
        self.root = root
        self.includingNavigationDestination = includingNavigationDestination
    }

    /// Binding for sheet presentations.
    private var presentedBinding: Binding<NavigationItem<AnyView>?> {
        Binding(
            get: { manager.presentedItems[root.id]?.mode.isSheet == true ? manager.presentedItems[root.id] : nil },
            set: { manager.presentedItems[root.id] = $0 }
        )
    }

    /// Binding for full-screen cover presentations.
    private var fullScreenBinding: Binding<NavigationItem<AnyView>?> {
        Binding(
            get: { manager.presentedItems[root.id]?.mode.isFullScreen == true ? manager.presentedItems[root.id] : nil },
            set: { manager.presentedItems[root.id] = $0 }
        )
    }

    func body(content: Content) -> some View {
        let base = content
            .sheet(item: presentedBinding) { item in
                item.view
                    .presentationDetents(item.mode.detents ?? [.large])
            }
            .fullScreenCover(item: fullScreenBinding) { item in
                item.view
            }

        if includingNavigationDestination {
            base.navigationDestination(for: NavigationItem<AnyView>.self) { item in
                item.view
            }
        } else {
            base
        }
    }
}
