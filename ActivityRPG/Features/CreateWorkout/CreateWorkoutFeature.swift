//
//  CreateWorkoutFeature.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import Foundation
import ComposableArchitecture
import SwiftData

@Reducer
public struct CreateWorkoutFeature {
    @ObservableState
    public struct State: Equatable {
        var date: Date
        var type: WorkoutType = .run
        var name: String = ""
        
        public init(initialDate: Date) {
            self.date = initialDate
        }
    }

    public enum SaveError: Error, Equatable {
        case failed(String)
    }

    public enum Action {
        case setType(WorkoutType)
        case setName(String)
        case saveTapped
        case saveFinished(Result<Void, SaveError>)
        case delegate(Delegate)

        public enum Delegate { case saved }
    }
    
    @Dependency(\.modelContainer) var container
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setType(t):
                state.type = t
                return .none
                
            case let .setName(s):
                state.name = s
                return .none
                
            case .saveTapped:
                let snapshot = (state.date, state.type, state.name)
                return .run { [container, snapshot] send in
                    do {
                        try await MainActor.run {
                            let ctx = ModelContext(container)
                            let w = Workout(date: snapshot.0, type: snapshot.1, name: snapshot.2)
                            ctx.insert(w)
                            try ctx.save()
                        }
                        await send(.saveFinished(.success(())))
                    } catch {
                        await send(.saveFinished(.failure(.failed(error.localizedDescription))))
                    }
                }
                
            case .saveFinished(.success):
                return .send(.delegate(.saved))
                
            case .saveFinished(.failure):
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
