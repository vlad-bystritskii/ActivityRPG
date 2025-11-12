//
//  DateFormatters.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import Foundation

enum DateFormatters {
    private static func configured(
        _ formatter: DateFormatter,
        calendar: Calendar,
        locale: Locale
    ) -> DateFormatter {
        formatter.calendar = calendar
        formatter.locale = locale
        return formatter
    }

    private static let shortDayMonthBase: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()

    private static let monthAbbreviationBase: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()

    private static let monthYearBase: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }()

    private static let yearBase: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    static let full: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()

    static func shortDayMonth(
        _ date: Date,
        _ calendar: Calendar,
        _ locale: Locale
    ) -> String {
        let formatter: DateFormatter = configured(
            shortDayMonthBase,
            calendar: calendar,
            locale: locale
        )
        return formatter.string(from: date)
    }

    static func monthAbbreviation(
        _ date: Date,
        _ calendar: Calendar,
        _ locale: Locale
    ) -> String {
        let formatter: DateFormatter = configured(
            monthAbbreviationBase,
            calendar: calendar,
            locale: locale
        )
        return formatter.string(from: date)
    }

    static func monthYearString(
        _ date: Date,
        _ calendar: Calendar,
        _ locale: Locale
    ) -> String {
        let formatter: DateFormatter = configured(
            monthYearBase,
            calendar: calendar,
            locale: locale
        )
        return formatter.string(from: date)
    }

    static func yearString(
        _ date: Date,
        _ calendar: Calendar,
        _ locale: Locale
    ) -> String {
        let formatter: DateFormatter = configured(
            yearBase,
            calendar: calendar,
            locale: locale
        )
        return formatter.string(from: date)
    }
}
