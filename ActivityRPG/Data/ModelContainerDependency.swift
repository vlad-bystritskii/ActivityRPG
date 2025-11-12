//
//  ModelContainerDependency.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import ComposableArchitecture
import SwiftData

private enum ModelContainerKey: DependencyKey {
  static let liveValue: ModelContainer = {
    try! ModelContainer(
      for: Schema([SkillNode.self, SkillUnlock.self]),
      configurations: [ModelConfiguration(isStoredInMemoryOnly: true)]
    )
  }()
  static let testValue = liveValue
}

public extension DependencyValues {
  var modelContainer: ModelContainer {
    get { self[ModelContainerKey.self] }
    set { self[ModelContainerKey.self] = newValue }
  }
}
