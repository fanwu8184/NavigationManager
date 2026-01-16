import SwiftUI

/// Represents an alert to be presented by the navigation manager.
struct NavigationAlert: Identifiable {
  let id: String
  let title: String
  private let makeActions: () -> AnyView
  private let makeMessage: (() -> AnyView)?

  var actions: AnyView { makeActions() }
  var message: AnyView? { makeMessage?() }

  /// Initializes a navigation alert with a title, actions, and a message.
  init<A: View, M: View>(
    title: String,
    @ViewBuilder actions: @escaping () -> A,
    @ViewBuilder message: @escaping () -> M
  ) {
    self.id = UUID().uuidString
    self.title = title
    self.makeActions = { AnyView(actions()) }
    self.makeMessage = { AnyView(message()) }
  }

  /// Initializes a navigation alert with a title and actions.
  init<A: View>(
    title: String,
    @ViewBuilder actions: @escaping () -> A
  ) {
    self.id = UUID().uuidString
    self.title = title
    self.makeActions = { AnyView(actions()) }
    self.makeMessage = nil
  }
}
