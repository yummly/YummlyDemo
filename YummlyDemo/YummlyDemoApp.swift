//
//  YummlyDemoApp.swift
//  YummlyDemo
//
//  Created by Praveen Nagaraj on 11/6/23.
//

import SwiftUI

@main
struct YummlyDemoApp: App {
  @Environment(\.scenePhase) var scenePhase
  @StateObject var store = Store()

  var body: some Scene {
    WindowGroup {
      TabView {
        HomeView()
          .environmentObject(store)
          .tabItem {
            Label("Home", systemImage: "house")
          }
        CollectionsView()
          .environmentObject(store)
          .tabItem {
            Label("Collections", systemImage: "heart")
          }
        MealPlannerView()
          .tabItem {
            Label("Meal Planner", systemImage: "calendar")
          }
        ShoppingListView()
          .tabItem {
            Label("Shopping List", systemImage: "checklist")
          }
        SearchView()
          .tabItem {
            Label("Search", systemImage: "magnifyingglass")
          }
      }
    }
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
          print("Active")
      } else if newPhase == .inactive {
          print("Inactive")
      } else if newPhase == .background {
          print("Background")
        store.reset()
      }
    }
  }
}
