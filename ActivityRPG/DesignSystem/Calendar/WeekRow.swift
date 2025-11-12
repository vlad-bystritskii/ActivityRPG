//
//  WeekRow.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import SwiftUI

struct WeekRow: View {
    let startOfWeek: Date
    let calendar: Calendar
    let selectedDate: Date
    let onSelect: (Date) -> Void

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<7, id: \.self) { dayOffset in
                let dayDate: Date = calendar.date(
                    byAdding: .day,
                    value: dayOffset,
                    to: startOfWeek
                ) ?? startOfWeek

                DayCell(
                    date: dayDate,
                    isSelected: calendar.isDate(dayDate, inSameDayAs: selectedDate),
                    isToday: calendar.isDateInToday(dayDate),
                    calendar: calendar,
                    onTap: {
                        onSelect(dayDate)
                    }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 0)
    }
}

#Preview("WeekRow") {
    let cal: Calendar = Calendar(identifier: .iso8601)
    let start: Date = Date().startOfWeek(using: cal)
    return WeekRow(
        startOfWeek: start,
        calendar: cal,
        selectedDate: Date(),
        onSelect: { _ in }
    )
    .environment(\.locale, Locale(identifier: "ru_RU"))
    .padding()
}

