//
//  ExerciseModel.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 10/11/2025.
//

import Foundation
import SwiftData

@Model
public final class ExerciseModel {
    public var id: UUID
    public var createdAt: Date
    public var type: ExerciseType
    public var name: String
    public var measurements: [MeasurementKind]

    public init(
        id: UUID = .init(),
        createdAt: Date = .now,
        type: ExerciseType,
        name: String,
        measurements: [MeasurementKind]
    ) {
        self.id = id
        self.createdAt = createdAt
        self.type = type
        self.name = name
        self.measurements = measurements
    }
}
