//
//  Date+StartOfWeek.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import Foundation

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }

    func startOfWeek(using calendar: Calendar) -> Date {
        let components: DateComponents = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: self
        )
        return calendar.date(from: components) ?? self
    }

    var weekStrip: [Date] {
        let calendar: Calendar = Calendar.current
        let interval: DateInterval = calendar.dateInterval(of: .weekOfYear, for: self.startOfDay)!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: interval.start)! }
    }

    var dayBounds: (Date, Date) {
        let calendar: Calendar = Calendar.current
        let start: Date = calendar.startOfDay(for: self)
        let end: Date = calendar.date(byAdding: .day, value: 1, to: start)!
        return (start, end)
    }
}
