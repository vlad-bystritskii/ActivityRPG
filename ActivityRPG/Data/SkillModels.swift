//
//  SkillModels.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import Foundation
import SwiftData

public enum Attribute: String, Codable, CaseIterable, Sendable {
    case agility
    case strength
    case flexibility
    case endurance
}

@Model
public final class SkillNode: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID = UUID()
    public var title: String = ""
    public var attribute: Attribute = Attribute.agility
    public var posX: Double = 0
    public var posY: Double = 0
    public var cost: Int = 1
    public var requires: [UUID] = []
    public var effectsJSON: String? = nil
    
    public init(
        id: UUID = UUID(),
        title: String = "",
        attribute: Attribute = Attribute.agility,
        posX: Double = 0,
        posY: Double = 0,
        cost: Int = 1,
        requires: [UUID] = [],
        effectsJSON: String? = nil
    ) {
        self.id = id
        self.title = title
        self.attribute = attribute
        self.posX = posX
        self.posY = posY
        self.cost = cost
        self.requires = requires
        self.effectsJSON = effectsJSON
    }
}

@Model
public final class SkillUnlock: Identifiable, Equatable {
    @Attribute(.unique) public var id: UUID = UUID()
    public var nodeId: UUID = UUID()
    public var unlockedAt: Date = Date.now
    
    public init(
        id: UUID = UUID(),
        nodeId: UUID,
        unlockedAt: Date = Date.now
    ) {
        self.id = id
        self.nodeId = nodeId
        self.unlockedAt = unlockedAt
    }
}
