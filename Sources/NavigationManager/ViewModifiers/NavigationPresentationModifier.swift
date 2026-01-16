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
  
  /// Binding for alert presentations.
  private var alertBinding: Binding<Bool> {
    Binding(
      get: { manager.alertItems[root.id] != nil },
      set: { if !$0 { manager.alertItems[root.id] = nil } }
    )
  }
  
  @State private var sheetHeight: CGFloat = .zero
  
  func body(content: Content) -> some View {
    let base = content
      .sheet(item: presentedBinding) { item in
        if item.mode.isScalable {
          item.view
            .readHeight { height in
              sheetHeight = height
            }
            .presentationDetents(sheetHeight > 0 ? [.height(sheetHeight)] : [.large])
        } else {
          item.view
            .presentationDetents(item.mode.detents ?? [.large])
        }
      }
      .fullScreenCover(item: fullScreenBinding) { item in
        item.view
      }
      .alert(
        manager.alertItems[root.id]?.title ?? "",
        isPresented: alertBinding,
        actions: {
          if let item = manager.alertItems[root.id] {
            item.actions
          }
        },
        message: {
          if let item = manager.alertItems[root.id] {
            item.message
          }
        }
      )
    
    if includingNavigationDestination {
      base.navigationDestination(for: NavigationItem<AnyView>.self) { item in
        item.view
      }
    } else {
      base
    }
  }
}
