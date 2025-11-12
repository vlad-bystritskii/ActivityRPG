//
//  MeasurementKind.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 10/11/2025.
//

public enum MeasurementKind: String, Codable, CaseIterable, Hashable {
    case reps
    case weight
    case time
    case distance

    var title: String {
        switch self {
        case .reps: return "Повторы"
        case .weight: return "Вес"
        case .time: return "Время"
        case .distance: return "Дистанция"
        }
    }
}
