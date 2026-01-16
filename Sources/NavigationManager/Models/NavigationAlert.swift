import SwiftUI

/// Represents an alert to be presented by the navigation manager.
struct NavigationAlert: Identifiable {
  let id: String
  let title: String
  let actions: AnyView
  let message: AnyView?

  /// Initializes a navigation alert with a title, actions, and a message.
  init<A: View, M: View>(
    title: String,
    @ViewBuilder actions: () -> A,
    @ViewBuilder message: () -> M
  ) {
    self.id = UUID().uuidString
    self.title = title
    self.actions = AnyView(actions())
    self.message = AnyView(message())
  }

  /// Initializes a navigation alert with a title and actions.
  init<A: View>(
    title: String,
    @ViewBuilder actions: () -> A
  ) {
    self.id = UUID().uuidString
    self.title = title
    self.actions = AnyView(actions())
    self.message = nil
  }
}
