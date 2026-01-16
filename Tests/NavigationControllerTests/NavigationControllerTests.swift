import Testing
import SwiftUI
@testable import NavigationManager

// MARK: - Mock Navigable Screen
struct MockScreen: NavigableScreen {
  let id: String

  @MainActor
  @ViewBuilder
  func contentView() -> some View {
    Text(id)
  }

  static func == (lhs: MockScreen, rhs: MockScreen) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

@MainActor
struct NavigationManagerTests {
  let navigationManager: NavigationManager

  init() {
    navigationManager = NavigationManager()
  }

  @Test("When initialized Then the properties in NavigationManager should be set correctly")
  func testInitial() {
    #expect(navigationManager.selectedTab.isEmpty == true)
    #expect(navigationManager.stackPaths.isEmpty == true)
    #expect(navigationManager.presentedItems.isEmpty == true)
  }

  @Test("When push a single screen Then the stackPaths should contain correct path")
  func testPushSingleScreen() {
    let root = MockScreen(id: "root")
    let child = MockScreen(id: "child")
    navigationManager.push(from: root, to: child)
    #expect(navigationManager.stackPaths[root.id]?.count == 1)
    #expect(navigationManager.stackPaths[root.id]?.last?.id.contains("child") == true)
  }

  @Test("When push multiple screens Then the stackPaths should contain correct path")
  func testPushMultipleScreens() {
    let root = MockScreen(id: "root")
    let child1 = MockScreen(id: "child1")
    let child2 = MockScreen(id: "child2")
    navigationManager.push(screens: [root, child1, child2])
    #expect(navigationManager.stackPaths[root.id]?.count == 2)
    #expect(navigationManager.stackPaths[root.id]?.first?.id.contains("child1") == true)
    #expect(navigationManager.stackPaths[root.id]?.last?.id.contains("child2") == true)
  }

  @Test("When push multiple screens with a single screen Then the stackPaths should not contain the single screen")
  func testPushMultipleScreensWithSingleScreen() {
    let root = MockScreen(id: "root")
    navigationManager.push(screens: [root])
    #expect(navigationManager.stackPaths[root.id] == nil)
  }

  @Test("When present a sheet Then the presentedItems should contain the correct item")
  func testPresentSheet() {
    let root = MockScreen(id: "root")
    let child = MockScreen(id: "child")
    let detents: Set<PresentationDetent> = [.medium, .large]
    navigationManager.presentSheet(from: root, to: child, detents: detents)
    #expect(navigationManager.presentedItems[root.id]?.id.contains("child") == true)
    #expect(navigationManager.presentedItems[root.id]?.mode.isSheet == true)
    #expect(navigationManager.presentedItems[root.id]?.mode.detents == detents)
  }

  @Test("When present a full screen Then the presentedItems should contain the correct item")
  func testPresentFullScreen() {
    let root = MockScreen(id: "root")
    let child = MockScreen(id: "child")
    navigationManager.presentFullScreen(from: root, to: child)
    #expect(navigationManager.presentedItems[root.id]?.id.contains("child") == true)
    #expect(navigationManager.presentedItems[root.id]?.mode.isFullScreen == true)
  }

  @Test("When dismiss presented Item after presenting a sheet or a full screen Then the presentedItems should be nil")
  func testDismiss() {
    let root = MockScreen(id: "root")
    let child = MockScreen(id: "child")
    navigationManager.presentSheet(from: root, to: child)
    #expect(navigationManager.presentedItems[root.id] != nil)
    navigationManager.dismiss(from: root)
    #expect(navigationManager.presentedItems[root.id] == nil)
    navigationManager.presentFullScreen(from: root, to: child)
    #expect(navigationManager.presentedItems[root.id] != nil)
    navigationManager.dismiss(from: root)
    #expect(navigationManager.presentedItems[root.id] == nil)
  }

  @Test("When pop a single screen Then the stackPaths should not contain the popped screen")
  func testPop() {
    let root = MockScreen(id: "root")
    let child = MockScreen(id: "child")
    navigationManager.push(from: root, to: child)
    navigationManager.pop(from: root)
    #expect(navigationManager.stackPaths[root.id]?.contains(where: { $0.id.contains("child") }) != true)
  }

  @Test("When pop to root Then the stackPaths should be empty for the root")
  func testPopToRoot() {
    let root = MockScreen(id: "root")
    let child1 = MockScreen(id: "child1")
    let child2 = MockScreen(id: "child2")
    navigationManager.push(from: root, to: child1)
    navigationManager.push(from: root, to: child2)
    navigationManager.popToRoot(from: root)
    #expect(navigationManager.stackPaths[root.id]?.isEmpty ?? true)
  }

  @Test("When select a tab Then the selectedTab should be set correctly")
  func testSelectTab() {
    let root = MockScreen(id: "root")
    let child = MockScreen(id: "child")
    navigationManager.selectTab(from: root, to: child)
    #expect(navigationManager.selectedTab[root.id] == child.id)
  }

  @Test("When selected a tab Then the getSelectedTabID should return correct ID")
  func testSelectedTabID() {
    let root = MockScreen(id: "root")
    let child = MockScreen(id: "child")
    navigationManager.selectTab(from: root, to: child)
    let selectedID = navigationManager.getSelectedTabID(for: root)
    #expect(selectedID == child.id)
  }

  @Test("When reset all states Then the selectedTab, stackPaths, and presentedItems should be empty")
  func testReset() {
    let root = MockScreen(id: "root")
    let child = MockScreen(id: "child")
    navigationManager.push(from: root, to: child)
    navigationManager.presentSheet(from: root, to: child)
    navigationManager.selectTab(from: root, to: child)
    #expect(navigationManager.selectedTab.isEmpty == false)
    #expect(navigationManager.stackPaths.isEmpty == false)
    #expect(navigationManager.presentedItems.isEmpty == false)
    navigationManager.reset()
    #expect(navigationManager.selectedTab.isEmpty == true)
    #expect(navigationManager.stackPaths.isEmpty == true)
    #expect(navigationManager.presentedItems.isEmpty == true)
  }

  @Test("When reset stacks for a root Then the stackPaths for that root should be empty")
  func testResetStacks() {
    let root = MockScreen(id: "root")
    let child = MockScreen(id: "child")
    navigationManager.push(from: root, to: child)
    navigationManager.resetStacks(in: root)
    #expect(navigationManager.stackPaths[root.id]?.isEmpty == true)
  }
}
