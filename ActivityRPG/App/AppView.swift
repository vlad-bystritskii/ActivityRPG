//
//  AppView.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
  let store: StoreOf<AppReducer>

  var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.path)) {
      SkillTreeView(store: store.scope(state: \.skillTree, action: \.skillTree))
    } destination: { _ in
      EmptyView()
    }
  }
}
