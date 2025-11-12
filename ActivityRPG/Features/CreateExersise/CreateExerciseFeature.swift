//
//  CreateExerciseFeature.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 10/11/2025.
//

import Foundation
import ComposableArchitecture
import SwiftData

@Reducer
public struct CreateExerciseFeature {
    @ObservableState
    public struct State: Equatable {
        var type: ExerciseType = .strength
        var name: String = ""
        var isSaving: Bool = false

        var measurements: Set<MeasurementKind> = [.reps]
        var primaryMeasurement: MeasurementKind = .reps

        public init() {}
    }

    public enum SaveError: Error, Equatable {
        case validationEmpty
        case duplicate
        case failed(String)
    }

    public enum Action: Equatable {
        case setType(ExerciseType)
        case setName(String)

        case toggleMeasurement(MeasurementKind)
        case setPrimaryMeasurement(MeasurementKind)

        case saveTapped
        case saveSucceeded
        case saveFailed(SaveError)

        case delegate(Delegate)
        public enum Delegate: Equatable { case saved }
    }

    @Dependency(\.modelContainer) var container
    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case let .setType(t):
                state.type = t
                let rec = t.recommendedMeasurements
                state.measurements = Set(rec)
                state.primaryMeasurement = rec.first ?? .reps
                return .none

            case let .setName(s):
                state.name = s
                return .none

            case let .toggleMeasurement(kind):
                if state.measurements.contains(kind) {
                    if state.measurements.count == 1 { return .none }
                    state.measurements.remove(kind)
                    if state.primaryMeasurement == kind {
                        state.primaryMeasurement = state.measurements.first ?? .reps
                    }
                } else {
                    state.measurements.insert(kind)
                }
                return .none

            case let .setPrimaryMeasurement(kind):
                if !state.measurements.contains(kind) {
                    state.measurements.insert(kind)
                }
                state.primaryMeasurement = kind
                return .none

            case .saveTapped:
                let normalizedName = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !normalizedName.isEmpty else {
                    return .send(.saveFailed(.validationEmpty))
                }

                state.isSaving = true
                let ordered: [MeasurementKind] = {
                    let rest = state.measurements.subtracting([state.primaryMeasurement]).sorted { $0.rawValue < $1.rawValue }
                    return [state.primaryMeasurement] + rest
                }()
                let snapshot = (state.type, normalizedName, ordered)

                return .run { [container, snapshot] send in
                    do {
                        try await MainActor.run {
                            let ctx = ModelContext(container)

                            let t = snapshot.0
                            let n = snapshot.1
                            let fetch = FetchDescriptor<ExerciseModel>(
                                predicate: #Predicate { $0.type == t && $0.name == n }
                            )
                            let existing = try ctx.fetch(fetch)
                            if !existing.isEmpty { throw SaveError.duplicate }

                            let e = ExerciseModel(
                                type: snapshot.0,
                                name: snapshot.1,
                                measurements: snapshot.2
                            )
                            ctx.insert(e)
                            try ctx.save()
                        }
                        await send(.saveSucceeded)
                    } catch let err as SaveError {
                        await send(.saveFailed(err))
                    } catch {
                        await send(.saveFailed(.failed(error.localizedDescription)))
                    }
                }

            case .saveSucceeded:
                state.isSaving = false
                return .send(.delegate(.saved))

            case .saveFailed:
                state.isSaving = false
                return .none

            case .delegate:
                return .none
            }
        }
    }
}

