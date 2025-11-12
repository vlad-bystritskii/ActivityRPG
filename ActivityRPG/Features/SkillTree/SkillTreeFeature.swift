//
//  SkillTreeFeature.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import ComposableArchitecture
import CoreGraphics
import SwiftData
import Foundation

@Reducer
public struct SkillTreeFeature {
    @ObservableState
    public struct State: Equatable {
        var nodes: [SkillNodeDTO] = []
        var unlocked: Set<UUID> = []
        var selected: UUID?
        var offset: CGPoint = .zero
        var scale: Double = 1.0
    }

    public enum Action {
        case onAppear
        case nodesLoaded([SkillNodeDTO])
        case unlocksLoaded(Set<UUID>)
        case nodeTapped(UUID)
        case toggleUnlock(UUID)
        case unlocksUpdated(Set<UUID>)
        case commitPan(CGPoint)
        case commitScale(Double)
    }

    @Dependency(\.modelContainer) var container

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .run { [container] send in
                        let nodes: [SkillNodeDTO] = try await MainActor.run {
                            try SkillSeed.seedIfNeeded(container: container)
                            let ctx = ModelContext(container)
                            let models = try ctx.fetch(FetchDescriptor<SkillNode>())
                            return models.map {
                                SkillNodeDTO(
                                    id: $0.id, title: $0.title, sphere: $0.sphere,
                                    posX: $0.posX, posY: $0.posY, cost: $0.cost, requires: $0.requires
                                )
                            }
                        }
                        await send(.nodesLoaded(nodes))
                    },
                    .run { [container] send in
                        let ids: Set<UUID> = try await MainActor.run {
                            let ctx = ModelContext(container)
                            let d = FetchDescriptor<SkillUnlock>(sortBy: [SortDescriptor(\.unlockedAt, order: .forward)])
                            return Set(try ctx.fetch(d).map(\.nodeId))
                        }
                        await send(.unlocksLoaded(ids))
                    }
                )

            case let .nodesLoaded(nodes):
                state.nodes = nodes; return .none

            case let .unlocksLoaded(ids):
                state.unlocked = ids; return .none

            case let .nodeTapped(id):
                state.selected = id; return .none

            case let .toggleUnlock(id):
                return .run { [container] send in
                    let ids: Set<UUID> = try await MainActor.run {
                        let ctx = ModelContext(container)
                        let d = FetchDescriptor<SkillUnlock>(predicate: #Predicate { $0.nodeId == id })
                        if let u = try ctx.fetch(d).first { ctx.delete(u) } else { ctx.insert(SkillUnlock(nodeId: id)) }
                        try ctx.save()
                        return Set(try ctx.fetch(FetchDescriptor<SkillUnlock>()).map(\.nodeId))
                    }
                    await send(.unlocksUpdated(ids))
                }

            case let .unlocksUpdated(ids):
                state.unlocked = ids; return .none

            case let .commitPan(p):
                state.offset = p; return .none

            case let .commitScale(v):
                state.scale = max(0.5, min(2.0, v)); return .none
            }
        }
    }
}
