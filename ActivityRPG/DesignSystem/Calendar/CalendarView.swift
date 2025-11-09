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

            let currentWeekStart: Date = calendar.date(byAdding: .day, value: weekPageOffset * 7, to: anchorWeekStartDate) ?? anchorWeekStartDate
            Text(weekTitle(for: currentWeekStart))
                .font(.caption)
                .foregroundStyle(.secondary)
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
        let newAnchor: Date = calendar.date(byAdding: .day, value: shiftWeeks * 7, to: anchorWeekStartDate) ?? anchorWeekStartDate
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

    private func weekTitle(for start: Date) -> String {
        let end: Date = calendar.date(byAdding: .day, value: 6, to: start) ?? start
        let isSameMonth: Bool = calendar.isDate(start, equalTo: end, toGranularity: .month)
        let isSameYear: Bool = calendar.isDate(start, equalTo: end, toGranularity: .year)

        if isSameMonth && isSameYear {
            let left: String = DateFormatters.shortDayMonth(start, calendar, locale)
            let rightDay: Int = calendar.component(.day, from: end)
            let rightMonth: String = DateFormatters.monthAbbreviation(
                end,
                calendar,
                locale
            )
            let year: String = DateFormatters.yearString(end, calendar, locale)
            return "\(left)–\(rightDay) \(rightMonth) \(year)"
        } else if isSameYear {
            let left: String = DateFormatters.shortDayMonth(start, calendar, locale)
            let right: String = DateFormatters.shortDayMonth(end, calendar, locale)
            let year: String = DateFormatters.yearString(end, calendar, locale)
            return "\(left) – \(right) \(year)"
        } else {
            let left: String = DateFormatters.shortDayMonth(start, calendar, locale)
            let leftYear: String = DateFormatters.yearString(start, calendar, locale)
            let right: String = DateFormatters.shortDayMonth(end, calendar, locale)
            let rightYear: String = DateFormatters.yearString(end, calendar, locale)
            return "\(left) \(leftYear) – \(right) \(rightYear)"
        }
    }
}

#Preview("CalendarView") {
    CalendarView(selectedDate: .constant(Date()))
        .environment(\.calendar, Calendar(identifier: .iso8601))
        .environment(\.locale, Locale(identifier: "ru_RU"))
        .padding()
}
