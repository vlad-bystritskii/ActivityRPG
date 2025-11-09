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
        var nodes: [SkillNode] = []
        var unlocked: Set<UUID> = []
        var selected: UUID?
        var offset: CGPoint = .zero
        var scale: Double = 1.0
    }

    public enum Action {
        case onAppear
        case nodesLoaded([SkillNode])
        case unlocksLoaded([SkillUnlock])
        case nodeTapped(UUID)
        case toggleUnlock(UUID)
        case unlocksUpdated([SkillUnlock])
        case pinchChanged(Double)
        case dragChanged(CGPoint)
        case dragEnded
    }

    @Dependency(\.skillTreeClient) var skillTree
    @Dependency(\.modelContainer) var container    // из SwiftDataEnvironment

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // Привяжем live-клиент к текущему контейнеру
                let client = SkillTreeClient(
                    loadNodes: {
                        try SkillSeed.seedIfNeeded(container: container)
                        let ctx = ModelContext(container)
                        return try ctx.fetch(FetchDescriptor<SkillNode>())
                    },
                    loadUnlocks: {
                        let ctx = ModelContext(container)
                        let d = FetchDescriptor<SkillUnlock>(sortBy: [SortDescriptor(\.unlockedAt, order: .forward)])
                        return try ctx.fetch(d)
                    },
                    toggleUnlock: { nodeId in
                        let ctx = ModelContext(container)
                        let d = FetchDescriptor<SkillUnlock>(predicate: #Predicate { $0.nodeId == nodeId })
                        if let u = try ctx.fetch(d).first { ctx.delete(u) } else { ctx.insert(SkillUnlock(nodeId: nodeId)) }
                        try ctx.save()
                        return try ctx.fetch(FetchDescriptor<SkillUnlock>())
                    }
                )

                return .merge(
                    .run { [client] send in let n = try await client.loadNodes(); await send(.nodesLoaded(n)) },
                    .run { [client] send in let u = try await client.loadUnlocks(); await send(.unlocksLoaded(u)) }
                )

            case let .nodesLoaded(nodes):
                state.nodes = nodes
                return .none

            case let .unlocksLoaded(unlocks):
                state.unlocked = Set(unlocks.map(\.nodeId))
                return .none

            case let .nodeTapped(id):
                state.selected = id
                return .none

            case let .toggleUnlock(id):
                let client = makeClient()
                return .run { send in let u = try await client.toggleUnlock(id); await send(.unlocksUpdated(u)) }

            case let .unlocksUpdated(unlocks):
                state.unlocked = Set(unlocks.map(\.nodeId))
                return .none

            case let .pinchChanged(scale):
                state.scale = max(0.5, min(2.0, scale))
                return .none

            case let .dragChanged(p):
                state.offset.x += p.x
                state.offset.y += p.y
                return .none

            case .dragEnded:
                return .none
            }
        }
    }

    private func makeClient() -> SkillTreeClient {
        SkillTreeClient(
            loadNodes: { fatalError() },
            loadUnlocks: { fatalError() },
            toggleUnlock: { nodeId in
                let ctx = ModelContext(container)
                let d = FetchDescriptor<SkillUnlock>(predicate: #Predicate { $0.nodeId == nodeId })
                if let u = try ctx.fetch(d).first { ctx.delete(u) } else { ctx.insert(SkillUnlock(nodeId: nodeId)) }
                try ctx.save()
                return try ctx.fetch(FetchDescriptor<SkillUnlock>())
            }
        )
    }
}

