//
//  SkillModels.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import Foundation
import SwiftData

public enum Sphere: String, Codable, CaseIterable { case runner, strength, grappler, scout }

@Model
public final class SkillNode: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var sphere: Sphere
    public var posX: Double
    public var posY: Double
    public var cost: Int
    public var requires: [UUID]
    public var effectsJSON: String?

    public init(
        id: UUID = UUID(),
        title: String,
        sphere: Sphere,
        posX: Double,
        posY: Double,
        cost: Int = 1,
        requires: [UUID] = [],
        effectsJSON: String? = nil
    ) {
        self.id = id
        self.title = title
        self.sphere = sphere
        self.posX = posX
        self.posY = posY
        self.cost = cost
        self.requires = requires
        self.effectsJSON = effectsJSON
    }
}

@Model
public final class SkillUnlock: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID
    public var nodeId: UUID
    public var unlockedAt: Date

    public init(id: UUID = UUID(), nodeId: UUID, unlockedAt: Date = .now) {
        self.id = id
        self.nodeId = nodeId
        self.unlockedAt = unlockedAt
    }
}
