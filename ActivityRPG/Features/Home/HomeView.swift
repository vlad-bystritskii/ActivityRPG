//
//  HomeView.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<HomeFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 12) {
                CalendarView(
                    selectedDate: Binding<Date>(
                        get: { viewStore.selectedDate },
                        set: { viewStore.send(.dayTapped($0)) }
                    )
                )
                .padding(.top)

                List {
                    if viewStore.workouts.isEmpty {
                        Text("Нет тренировок")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewStore.workouts) { workout in
                            HStack {
                                Text(workout.type.rawValue).bold()
                                Spacer()
                                Text(workout.name)
                            }
                        }
                    }
                }
                .listStyle(.plain)

                Button {
                    viewStore.send(.createTapped(viewStore.selectedDate))
                } label: {
                    Label("Создать тренировку", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

#Preview("HomeView") {
    NavigationStack {
        HomeView(
            store: Store(
                initialState: HomeFeature.State(
                    selectedDate: Date(),
                    workouts: [
                        WorkoutDTO(
                            id: UUID(),
                            date: .now,
                            type: .grappling,
                            name: "Грудь и трицепс"
                        ),
                        WorkoutDTO(
                            id: UUID(),
                            date: .now,
                            type: .hike,
                            name: "Бег 5 км"
                        ),
                        WorkoutDTO(
                            id: UUID(),
                            date: .now,
                            type: .run,
                            name: "Растяжка 15 мин"
                        )
                    ]
                ),
                reducer: { HomeFeature() }
            )
        )
    }
}
