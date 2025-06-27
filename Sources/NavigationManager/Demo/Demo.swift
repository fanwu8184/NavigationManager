import SwiftUI

enum AppScreen: String, CaseIterable {
    case root, a, b, c, d, e, f, ba, bb, bc
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

    static func from(_ rawValue: String) -> AppScreen? {
        allCases.first { $0.rawValue.lowercased() == rawValue.lowercased() }
    }
}

struct AView: View {
    @Environment(NavigationManager.self) private var manager

    var body: some View {
        VStack {
            Text("A View")
            Button("Go to B") {
                manager.selectTab(from: AppScreen.root, to: AppScreen.b)
            }
            Button("Go to C") {
                manager.presentSheet(from: AppScreen.a, to: AppScreen.c)
            }
            Button("Go to D") {
                manager.presentFullScreen(from: AppScreen.a, to: AppScreen.d)
            }
            Button("Go to E") {
                manager.push(from: AppScreen.a, to: AppScreen.e)
            }
        }
        .managedNavigationStack(root: AppScreen.a)
    }
}

struct BView: View {
    @Environment(NavigationManager.self) private var manager

    var body: some View {
        VStack {
            Text("B View")
            Button("Go to BA") {
                manager.push(from: AppScreen.b, to: AppScreen.ba)
            }
        }
        .managedNavigationStack(root: AppScreen.b)
    }
}

struct CView: View {
    @Environment(NavigationManager.self) private var manager

    var body: some View {
        VStack {
            Text("C View")
            Button("Go to D") {
                manager.presentSheet(from: AppScreen.c, to: AppScreen.d)
            }
            Button("Go to E") {
                manager.push(from: AppScreen.c, to: AppScreen.e)
            }
        }
        .managedNavigationStack(root: AppScreen.c)
    }
}

struct DView: View {
    @Environment(NavigationManager.self) private var manager

    var body: some View {
        VStack {
            Text("D View")
            Button("Dismiss") {
                manager.dismiss(from: AppScreen.a)
            }
        }
    }
}

struct EView: View {
    @Environment(NavigationManager.self) private var manager

    var body: some View {
        VStack {
            Text("E View")
            Button("Go to F") {
                manager.push(from: AppScreen.a, to: AppScreen.f)
            }
            Button("Go to C") {
                manager.presentSheet(from: AppScreen.a, to: AppScreen.c)
            }
        }
    }
}

struct FView: View {
    @Environment(NavigationManager.self) private var manager

    var body: some View {
        VStack {
            Text("F View")
            Button("pop") {
                manager.pop(from: AppScreen.a)
            }
            Button("go to root") {
                manager.popToRoot(from: AppScreen.a)
            }
        }
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
                    .background(manager.selectedTabID(for: AppScreen.ba) == tab.id ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(5)
                }
            }
            .padding()

            if let id = manager.selectedTabID(for: AppScreen.ba) {
                AppScreen.from(id)?.contentView()
            }
        }
        .task {
            if manager.selectedTabID(for: AppScreen.ba) == nil {
                manager.selectTab(from: AppScreen.ba, to: AppScreen.bb)
            }
        }
    }
}

struct BBView: View {
    var body: some View {
        ZStack {
            Color.red
            Text("BB View")
        }
    }
}

struct BCView: View {
    var body: some View {
        ZStack {
            Color.blue
            Text("BC View")
        }
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

