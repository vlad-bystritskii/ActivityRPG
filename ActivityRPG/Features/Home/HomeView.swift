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
                // 1) Однострочный календарь
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewStore.week, id: \.self) { day in
                            DayPill(
                                date: day,
                                selected: day.isSameDay(as: viewStore.selectedDate)
                            )
                            .onTapGesture { viewStore.send(.dayTapped(day)) }
                        }
                    }
                    .padding(.horizontal)
                }

                // 2) Сегодняшние тренировки
                List {
                    if viewStore.workouts.isEmpty {
                        Text("Нет тренировок").foregroundStyle(.secondary)
                    } else {
                        ForEach(viewStore.workouts) { w in
                            HStack {
                                Text(w.type.rawValue).bold()
                                Spacer()
                                Text(w.name)
                            }
                        }
                    }
                }
                .listStyle(.plain)

                // 3) Кнопка создания
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
            .navigationTitle("Сегодня")
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

private struct DayPill: View {
    let date: Date
    let selected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(date.shortWeekdayUpper)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(date.dayString)
                .font(.headline)
                .frame(width: 34, height: 34)
                .background(Circle().fill(selected ? Color.accentColor.opacity(0.2) : Color.clear))
                .overlay(Circle().stroke(selected ? Color.accentColor : Color.gray.opacity(0.3)))
        }
        .frame(width: 56)
    }
}

// MARK: - Date helpers
public extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }

    var weekStrip: [Date] {
        let cal = Calendar.current
        let week = cal.dateInterval(of: .weekOfYear, for: self.startOfDay)!
        return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: week.start)! }
    }

    var dayBounds: (Date, Date) {
        let cal = Calendar.current
        let start = cal.startOfDay(for: self)
        let end = cal.date(byAdding: .day, value: 1, to: start)!
        return (start, end)
    }

    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    var shortWeekdayUpper: String {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "EE" // Пн, Вт ...
        return f.string(from: self).uppercased()
    }

    var dayString: String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: self)
    }
}

