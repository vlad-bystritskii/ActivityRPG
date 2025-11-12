//
//  HomeFeature.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import Foundation
import ComposableArchitecture
import SwiftData

@Reducer
public struct HomeFeature {
    @ObservableState
    public struct State: Equatable {
        var selectedDate: Date = .now.startOfDay
        var week: [Date] = Date().weekStrip
        var workouts: [WorkoutDTO] = []
        var isLoading: Bool = false
    }
    
    public enum Action {
        case onAppear
        case reloadRequested
        case dayTapped(Date)
        case createTapped(Date)
        case workoutsLoaded([WorkoutDTO])
    }
    
    @Dependency(\.modelContainer) var container
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear, .reloadRequested:
                state.week = state.selectedDate.weekStrip
                return .run { [container, date = state.selectedDate] send in
                    let items: [WorkoutDTO] = try await MainActor.run {
                        let context: ModelContext = ModelContext(container)
                        let (from, to) = date.dayBounds
                        let descriptor: FetchDescriptor<Workout> = FetchDescriptor<Workout>(
                            predicate: #Predicate { $0.date >= from && $0.date < to },
                            sortBy: [SortDescriptor(\.date, order: .forward)]
                        )
                        return try context.fetch(descriptor)
                            .map { .init(id: $0.id, date: $0.date, type: $0.type, name: $0.name) }
                    }
                    await send(.workoutsLoaded(items))
                }
                
            case let .dayTapped(date):
                state.selectedDate = date.startOfDay
                state.week = date.weekStrip
                return .send(.reloadRequested)
                
            case .createTapped:
                return .none
                
            case let .workoutsLoaded(items):
                state.workouts = items
                return .none
            }
        }
    }
}
