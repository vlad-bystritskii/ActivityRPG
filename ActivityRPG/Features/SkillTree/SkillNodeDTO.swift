//
//  SkillNodeDTO.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import Foundation

public struct SkillNodeDTO: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let title: String
    public let attribute: Attribute
    public let posX: Double
    public let posY: Double
    public let cost: Int
    public let requires: [UUID]
}
