//
//  CreateWorkoutView.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import SwiftUI
import ComposableArchitecture

struct CreateWorkoutView: View {
    let store: StoreOf<CreateWorkoutFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section("Название") {
                    TextField(
                        "Например: Вечерняя пробежка",
                        text: viewStore.binding(
                            get: \.name,
                            send: CreateWorkoutFeature.Action.setName
                        )
                    )
                }

                Section("Дата") {
                    DatePicker("", selection: viewStore.binding(
                        get: \.date,
                        send: { _ in .setName(viewStore.name) }
                    ), displayedComponents: .date)
                    .labelsHidden()
                    .disabled(true)
                }

                Section("Тип") {
                    Picker("Тип", selection: viewStore.binding(get: \.type, send: CreateWorkoutFeature.Action.setType)) {
                        ForEach(WorkoutType.allCases, id: \.self) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Новая тренировка")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") { viewStore.send(.saveTapped) }
                        .disabled(viewStore.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateWorkoutView(
            store: Store(
                initialState: CreateWorkoutFeature.State(initialDate: .now)
            ) {
                CreateWorkoutFeature()
            }
        )
    }
}
