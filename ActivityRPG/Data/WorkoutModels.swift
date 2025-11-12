//
//  WorkoutModels.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 09/11/2025.
//

import Foundation
import SwiftData

public enum WorkoutType: String, CaseIterable, Codable, Sendable, Equatable {
    case run = "Бег"
    case strength = "Сила"
    case grappling = "Борьба"
    case hike = "Хайкинг"
}

@Model
public final class Workout: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID = UUID()
    public var date: Date = Date.now
    public var typeRaw: String = WorkoutType.run.rawValue
    public var name: String = ""
    
    public var type: WorkoutType {
        get { WorkoutType(rawValue: typeRaw) ?? .run }
        set { typeRaw = newValue.rawValue }
    }
    
    public init(id: UUID = UUID(), date: Date = .now, type: WorkoutType, name: String) {
        self.id = id
        self.date = date
        self.typeRaw = type.rawValue
        self.name = name
    }
}

public struct WorkoutDTO: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let date: Date
    public let type: WorkoutType
    public let name: String
}

