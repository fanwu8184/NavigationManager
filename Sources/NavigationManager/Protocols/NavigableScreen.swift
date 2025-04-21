import SwiftUI

/// Protocol for screens that can be navigated to within the navigation system.
public protocol NavigableScreen: Identifiable, Hashable where ID == String {
    /// The content view to be displayed for this screen.
    associatedtype Content: View
    /*
     @ViewBuilder: Essential for ergonomic SwiftUI view composition, allowing flexible and idiomatic view hierarchies.

     @MainActor: Ensures thread safety for SwiftUI’s main-thread rendering, which is critical for NavigationStack destinations. The minor overhead is outweighed by the correctness guarantee, especially in a concurrent app.
     */
    /// Returns the content view for the screen.
    @MainActor
    @ViewBuilder
    func contentView() -> Content
}
