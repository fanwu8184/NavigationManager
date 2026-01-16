import SwiftUI

/// Defines the navigation mode for presenting a view in the navigation system.
enum NavigationMode {
  /// Pushes the view onto a navigation stack.
  case stack
  /// Presents the view as a sheet with optional presentation detents and scalability.
  case sheet(detents: Set<PresentationDetent> = [.large], isScalable: Bool = false)
  /// Presents the view as a full-screen cover.
  case fullScreen
  /// Selects the view as a tab in a tab bar.
  case tab

  /// Indicates whether the navigation mode is a sheet.
  var isSheet: Bool {
    if case .sheet = self { return true }
    return false
  }

  /// Indicates whether the navigation mode is a full-screen cover.
  var isFullScreen: Bool {
    if case .fullScreen = self { return true }
    return false
  }

  /// Returns the detents for sheet presentation, if applicable.
  var detents: Set<PresentationDetent>? {
    if case .sheet(let detents, _) = self { return detents }
    return nil
  }

  /// Returns whether the sheet is scalable.
  var isScalable: Bool {
    if case .sheet(_, let isScalable) = self { return isScalable }
    return false
  }
}
