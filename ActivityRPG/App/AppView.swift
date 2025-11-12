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
        let pathStore: Store<StackState<Route.State>, StackActionOf<Route>> =
        store.scope(state: \.path, action: \.path)

        NavigationStackStore(pathStore) {
            HomeView(store: store.scope(state: \.home, action: \.home))
                .toolbar {
                    NavigationLink("Skill Tree") {
                        SkillTreeView(store: store.scope(state: \.skillTree, action: \.skillTree))
                    }
                }
        } destination: { state in
            switch state {
            case .createWorkout:
                CaseLet(\Route.State.createWorkout, action: Route.Action.createWorkout) {
                    CreateWorkoutView(store: $0)
                }
            }
        }
    }
}
