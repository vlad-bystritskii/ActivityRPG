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
    var skillTree = SkillTreeFeature.State()
    var path: StackState<Route.State> = .init()
  }

  public enum Action {
    case skillTree(SkillTreeFeature.Action)
    case path(StackActionOf<Route>)
  }

  public init() {}

  public var body: some Reducer<State, Action> {
    Scope(state: \.skillTree, action: \.skillTree) { SkillTreeFeature() }
    Reduce { _, _ in .none }
      .forEach(\.path, action: \.path) { Route() }
  }
}

@Reducer
public struct Route {
  @ObservableState
  public enum State: Equatable {}
  public enum Action {}
    public var body: some Reducer<State, Action> {
        Reduce { _, _ in
            .none
        }
    }
}
