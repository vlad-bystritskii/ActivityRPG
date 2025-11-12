//
//  CalendarView.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.calendar) private var calendar: Calendar
    @Environment(\.locale) private var locale: Locale

    @Binding var selectedDate: Date

    @State private var anchorWeekStartDate: Date = Date().startOfWeek(
        using: Calendar.current
    )
    @State private var weekPageOffset: Int = 0

    private let surroundingPagesBuffer: Int = 6

    var body: some View {
        VStack(spacing: 8) {
            Text(
                DateFormatters.monthYearString(
                    selectedDate,
                    calendar,
                    locale
                ).firstUppercased
            )
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                ForEach(weekdaySymbols(), id: \.self) { symbol in
                    Text(symbol.uppercased())
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.secondary)
                }
            }

            TabView(selection: $weekPageOffset) {
                ForEach(
                    -surroundingPagesBuffer...surroundingPagesBuffer,
                     id: \.self
                ) { index in
                    let startOfWeek: Date = calendar.date(
                        byAdding: .day,
                        value: index * 7,
                        to: anchorWeekStartDate
                    ) ?? anchorWeekStartDate
                    WeekRow(
                        startOfWeek: startOfWeek,
                        calendar: calendar,
                        selectedDate: selectedDate,
                        onSelect: { date in
                            selectedDate = date
                        }
                    )
                    .tag(index)
                }
            }
            .frame(height: 60)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: weekPageOffset) { _, newValue in
                recenterIfNeeded(newValue)
            }
        }
        .padding(.horizontal)
        .onAppear {
            anchorWeekStartDate = selectedDate.startOfWeek(using: calendar)
            weekPageOffset = 0
        }
    }

    private func recenterIfNeeded(_ newOffset: Int) -> Void {
        guard abs(newOffset) >= surroundingPagesBuffer - 1 else { return }
        let shiftWeeks: Int = newOffset
        let newAnchor: Date = calendar.date(
            byAdding: .day,
            value: shiftWeeks * 7,
            to: anchorWeekStartDate
        ) ?? anchorWeekStartDate

        withAnimation(nil) {
            anchorWeekStartDate = newAnchor
            weekPageOffset = 0
        }
    }

    private func weekdaySymbols() -> [String] {
        var symbols: [String] = calendar.veryShortStandaloneWeekdaySymbols
        let firstWeekdayIndex: Int = max(0, calendar.firstWeekday - 1)
        if firstWeekdayIndex > 0 {
            let head: ArraySlice<String> = symbols[firstWeekdayIndex...]
            let tail: ArraySlice<String> = symbols[..<firstWeekdayIndex]
            symbols = Array(head + tail)
        }
        return symbols
    }
}

#Preview("CalendarView") {
    CalendarView(selectedDate: .constant(Date()))
        .environment(\.calendar, Calendar(identifier: .iso8601))
        .environment(\.locale, Locale(identifier: "ru_RU"))
        .padding()
}
