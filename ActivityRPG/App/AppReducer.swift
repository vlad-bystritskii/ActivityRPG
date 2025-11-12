//
//  AppReducer.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import ComposableArchitecture

@Reducer
public struct AppReducer {
    @ObservableState
    public struct State: Equatable {
        var home = HomeFeature.State()
        var skillTree = SkillTreeFeature.State()
        var path: StackState<Route.State> = .init()
    }

    public enum Action {
        case home(HomeFeature.Action)
        case skillTree(SkillTreeFeature.Action)
        case path(StackActionOf<Route>)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Scope(state: \.home, action: \.home) { HomeFeature() }
        Scope(state: \.skillTree, action: \.skillTree) { SkillTreeFeature() }

        Reduce { state, action in
            switch action {
            case .home(.createTapped(let date)):
                state.path.append(.createWorkout(.init(initialDate: date)))
                return .none
                
            case .path(.element(id: _, action: .createWorkout(.delegate(.saved)))):
                state.path.popLast()
                return .send(.home(.reloadRequested))

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) { Route() }
    }
}

@Reducer
public struct Route {
    @ObservableState
    public enum State: Equatable {
        case createWorkout(CreateWorkoutFeature.State)
    }

    public enum Action {
        case createWorkout(CreateWorkoutFeature.Action)
    }

    public var body: some Reducer<State, Action> {
        Scope(state: \.createWorkout, action: \.createWorkout) { CreateWorkoutFeature() }
    }
}
