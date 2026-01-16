import SwiftUI

enum AppScreen: String, CaseIterable {
  case root, a, b, c, d, e, f, ba, bb, bc, scalableSheet
}

extension AppScreen: NavigableScreen {
  var id: String {
    rawValue.uppercased()
  }

  func contentView() -> some View {
    switch self {
    case .root: HomeView()
    case .a: AView()
    case .b: BView()
    case .c: CView()
    case .d: DView()
    case .e: EView()
    case .f: FView()
    case .ba: BAView()
    case .bb: BBView()
    case .bc: BCView()
    case .scalableSheet: Color.red.frame(height: 200)
    }
  }

  @ViewBuilder
  func tabItem() -> some View {
    switch self {
    case .a:
      Label(title: { Text(id) }, icon: { Image(systemName: "a.circle") })
    case .b:
      Label(title: { Text(id) }, icon: { Image(systemName: "b.circle") })
    default:
      EmptyView()
    }
  }
}

struct AView: View {
  @Environment(NavigationManager.self) private var manager

  var body: some View {
    VStack {
      Button("Present alert with actions") {
        manager.presentAlert(from: AppScreen.a, title: "Alert title", actions: {
          /// A destructive button that appears in red.
          Button(role: .destructive) {
            // Perform the deletion
          } label: {
            Text("Delete")
          }

          /// A cancellation button that appears with bold text.
          Button("Cancel", role: .cancel) {
            // Perform cancellation
          }

          /// A general button.
          Button("OK") {
            // Dismiss without action
          }
        }, message: {
          Text("Alert message")
        })
      }
      Button("Present a scalable sheet") {
        manager.presentSheet(from: AppScreen.a, to: AppScreen.scalableSheet, isScalable: true)
      }
      Button("Go to Tab B from Root") {
        manager.selectTab(from: AppScreen.root, to: AppScreen.b)
      }
      Button("Present Nested Stack C With Sheet in A") {
        manager.presentSheet(from: AppScreen.a, to: AppScreen.c)
      }
      Button("Present D with Full Screen in A") {
        manager.presentFullScreen(from: AppScreen.a, to: AppScreen.d)
      }
      Button("Push E in A") {
        manager.push(from: AppScreen.a, to: AppScreen.e)
      }
    }
    .navigationTitle("Tab A")
    .managedNavigationStack(root: AppScreen.a)
  }
}

struct BView: View {
  @Environment(NavigationManager.self) private var manager

  var body: some View {
    VStack {
      Button("Push a customized Tab BA in B") {
        manager.push(from: AppScreen.b, to: AppScreen.ba)
      }
    }
    .navigationTitle("Tab B")
    .managedNavigationStack(root: AppScreen.b)
  }
}

struct CView: View {
  @Environment(NavigationManager.self) private var manager

  var body: some View {
    VStack {
      Button("Present D with Sheet in c") {
        manager.presentSheet(from: AppScreen.c, to: AppScreen.d)
      }
      Button("Push E to in C") {
        manager.push(from: AppScreen.c, to: AppScreen.e)
      }
    }
    .navigationTitle("Nested Stack C")
    .managedNavigationStack(root: AppScreen.c)
  }
}

struct DView: View {
  @Environment(NavigationManager.self) private var manager

  var body: some View {
    VStack {
      Text("D View")
      Button("Dismiss from A") {
        manager.dismiss(from: AppScreen.a)
      }
    }
  }
}

struct EView: View {
  @Environment(NavigationManager.self) private var manager

  var body: some View {
    VStack {
      Button("Push F in A") {
        manager.push(from: AppScreen.a, to: AppScreen.f)
      }
      Button("Present C with Sheet in A") {
        manager.presentSheet(from: AppScreen.a, to: AppScreen.c)
      }
    }
    .navigationTitle("E View")
  }
}

struct FView: View {
  @Environment(NavigationManager.self) private var manager

  var body: some View {
    VStack {
      Button("pop from A") {
        manager.pop(from: AppScreen.a)
      }
      Button("Pop all in Root") {
        manager.popToRoot(from: AppScreen.a)
      }
    }
    .navigationTitle("F View")
  }
}

struct BAView: View {
  @Environment(NavigationManager.self) private var manager
  let tabs: [AppScreen] = [.bb, .bc]

  var body: some View {
    VStack {
      HStack(spacing: 10) {
        ForEach(tabs) { tab in
          Button {
            manager.selectTab(from: AppScreen.ba, to: tab)
          } label: {
            Text(tab.id)
              .frame(maxWidth: .infinity)
          }
          .padding(8)
          .background(manager.getSelectedTabID(for: AppScreen.ba) == tab.id ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
          .cornerRadius(5)
        }
      }
      .padding()

      if let id = manager.getSelectedTabID(for: AppScreen.ba) {
        AppScreen(rawValue: id.lowercased())?.contentView()
      }
    }
    .task {
      if manager.getSelectedTabID(for: AppScreen.ba) == nil {
        manager.selectTab(from: AppScreen.ba, to: AppScreen.bb)
      }
    }
  }
}

struct BBView: View {
  var body: some View {
    ZStack {
      Color.red
    }
    .navigationTitle("Tab BB")
  }
}

struct BCView: View {
  var body: some View {
    ZStack {
      Color.blue
    }
    .navigationTitle("Tab BC")
  }
}

struct HomeView: View {
  private var manager = NavigationManager()
  let tabs: [AppScreen] = [.a, .b]

  var body: some View {
    // have to wrap forEach in Group to make withTabNavigation work in simulators
    Group {
      ForEach(tabs, id: \.id) { tab in
        tab.contentView()
          .tabItem { tab.tabItem() }
      }
      .managedTabNavigation(root: AppScreen.root, tabs: tabs)
    }
    .environment(manager)
  }
}

#Preview {
  HomeView()
}
