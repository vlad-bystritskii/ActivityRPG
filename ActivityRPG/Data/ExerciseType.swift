//
//  ExerciseType.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 10/11/2025.
//

import Foundation

public enum ExerciseType: String, Codable, CaseIterable {
    case strength
    case cardio
    case flexibility
    case martialArts

    var realName: String {
        switch self {
        case .strength:
            return "Силовая"
        case .cardio:
            return "Кардио"
        case .flexibility:
            return "Гибкость"
        case .martialArts:
            return "Единоборства"
        }
    }

    var subCategory: String {
        switch self {
        case .strength:
            return "Тренажёры, собственный вес, функциональные упражнения"
        case .cardio:
            return "Бег, велосипед, плавание, эллипс и т.п."
        case .flexibility:
            return "Растяжка, йога, пилатес, мобилити"
        case .martialArts:
            return "Бокс, борьба, джиу-джитсу, ММА и т.п."
        }
    }
}

extension ExerciseType {
    var recommendedMeasurements: [MeasurementKind] {
        switch self {
        case .strength: return [.reps, .weight, .time]
        case .cardio: return [.distance, .time]
        case .flexibility: return [.time]
        case .martialArts: return [.time, .reps]
        }
    }
}
