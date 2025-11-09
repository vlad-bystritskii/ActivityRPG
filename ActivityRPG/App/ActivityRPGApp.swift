//
//  ActivityRPGApp.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct ActivityRPGApp: App {
  // твой общий контейнер SwiftData
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([SkillNode.self, SkillUnlock.self])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    do { return try ModelContainer(for: schema, configurations: [config]) }
    catch { fatalError("Could not create ModelContainer: \(error)") }
  }()

  var body: some Scene {
    WindowGroup {
      AppView(
        store: Store(initialState: AppReducer.State()) {
          AppReducer()
            // ВАЖНО: прокидываем этот же контейнер в зависимость TCA
            .dependency(\.modelContainer, sharedModelContainer)
        }
      )
    }
    .modelContainer(sharedModelContainer)
  }
}
