//
//  DayCell.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import SwiftUI

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let calendar: Calendar
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                let dayNumber: String = String(calendar.component(.day, from: date))
                Text(dayNumber)
                    .font(.body.weight(.medium))
                    .frame(width: 32, height: 32)
                    .background(
                        Circle().fill(isSelected ? Color.accentColor : .clear)
                    )
                    .foregroundStyle(isSelected ? Color.white : Color.primary)

                Circle()
                    .frame(width: 4, height: 4)
                    .opacity(isToday && !isSelected ? 1 : 0)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        let base: String = DateFormatters.full.string(from: date)
        let suffix: String = isSelected ? ", выбранно" : ""
        return base + suffix
    }
}

#Preview("DayCell — варианты") {
    let cal: Calendar = Calendar(identifier: .iso8601)
    let today: Date = Date()
    let other: Date = cal.date(byAdding: .day, value: 1, to: today) ?? today

    return HStack(spacing: 12) {
        DayCell(
            date: today,
            isSelected: true,
            isToday: true,
            calendar: cal,
            onTap: {
            })
        DayCell(
            date: today,
            isSelected: false,
            isToday: true,
            calendar: cal,
            onTap: {
            })
        DayCell(
            date: other,
            isSelected: false,
            isToday: false,
            calendar: cal,
            onTap: {
            })
    }
    .padding()
}

