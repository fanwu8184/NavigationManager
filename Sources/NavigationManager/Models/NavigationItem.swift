import Foundation
import SwiftUI

/// Represents a navigable view item with a unique identifier and navigation mode.
/// It is Identifiable due to sheet item. It is Hashable due to NavigationStack's navigationDestination
struct NavigationItem<V: View>: Identifiable, Hashable {
    let id: String
    let view: V
    let mode: NavigationMode

    /// Initializes a navigation item with a view and navigation mode.
    init(
        id: String,
        view: V,
        mode: NavigationMode
    ) {
        self.id = id + UUID().uuidString
        self.view = view
        self.mode = mode
    }

    static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
