//
//  CreateExerciseView.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 10/11/2025.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct CreateExerciseView: View {
    let store: StoreOf<CreateExerciseFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section("Название") {
                    TextField(
                        "Введите название",
                        text: viewStore.binding(
                            get: \.name,
                            send: CreateExerciseFeature.Action.setName
                        )
                    )
                    .textInputAutocapitalization(.sentences)
                }

                Section("Тип упражнения") {
                    Picker("Выберите тип", selection: viewStore.binding(
                        get: \.type,
                        send: CreateExerciseFeature.Action.setType
                    )) {
                        ForEach(ExerciseType.allCases, id: \.self) { t in
                            Text(t.realName).tag(t)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Единицы измерения") {
                    ForEach(Array(MeasurementKind.allCases), id: \.self) { kind in
                        Button {
                            viewStore.send(.toggleMeasurement(kind))
                        } label: {
                            HStack {
                                Text(kind.title)
                                Spacer()
                                if viewStore.measurements.contains(kind) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.accent)
                                }
                            }
                        }
                    }

                    if !viewStore.measurements.isEmpty {
                        Picker("Основная", selection: viewStore.binding(
                            get: \.primaryMeasurement,
                            send: CreateExerciseFeature.Action.setPrimaryMeasurement
                        )) {
                            ForEach(Array(viewStore.measurements).sorted { $0.rawValue < $1.rawValue }, id: \.self) { m in
                                Text(m.title).tag(m)
                            }
                        }
                        .pickerStyle(.menu)
                        .font(.callout)
                    }
                }
            }
            .navigationTitle("Создание упражнения")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") { viewStore.send(.saveTapped) }
                        .disabled(
                            viewStore.isSaving ||
                            viewStore.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        )
                }
            }
        }
    }
}



#Preview("Создание упражнения") {
    NavigationStack {
        CreateExerciseView(
            store: Store(
                initialState: CreateExerciseFeature.State()
            ) {
                CreateExerciseFeature()
            }
        )
    }
}
