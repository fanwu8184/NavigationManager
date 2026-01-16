import SwiftUI

public extension View {
  /// Enables sheet and full-screen cover presentations for the view without embedding in a NavigationStack.
  func navigationPresentable(root: any NavigableScreen) -> some View {
    modifier(NavigationCapableContainer(root: root))
  }
  
  /// Embeds the view in a NavigationStack, enabling stack-based navigation and supporting sheet and full-screen cover presentations.
  func managedNavigationStack(root: any NavigableScreen, tint: Color? = nil) -> some View {
    modifier(NavigationStackContainer(root: root, tint: tint))
  }
  
  /// Embeds the view in a TabView with selection binding, enabling tab-based navigation. Requires tab content (e.g., via ForEach) matching the provided tabs array.
  func managedTabNavigation(root: any NavigableScreen, tabs: [any NavigableScreen]) -> some View {
    modifier(TabNavigationContainer(root: root, tabs: tabs))
  }
}

extension View {
  /// Reads the height of the view and reports it via a completion handler.
  func readHeight(onChange: @escaping (CGFloat) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: HeightPreferenceKey.self, value: geometryProxy.size.height)
      }
    )
    .onPreferenceChange(HeightPreferenceKey.self, perform: onChange)
  }
}

/// Preference key for tracking view height.
private struct HeightPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat { 0 }
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
