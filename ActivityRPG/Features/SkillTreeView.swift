//
//  SkillTreeView.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import SwiftUI
import ComposableArchitecture

struct SkillTreeView: View {
    let store: StoreOf<SkillTreeFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { proxy in
                let W = proxy.size.width, H = proxy.size.height
                let scale = viewStore.scale, offset = viewStore.offset

                ZStack {
                    // edges
                    Canvas { ctx, size in
                        let nodes = viewStore.nodes
                        let map = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0) })
                        for node in nodes {
                            let p1 = CGPoint(x: node.posX * size.width * scale + offset.x,
                                             y: node.posY * size.height * scale + offset.y)
                            for req in node.requires {
                                if let src = map[req] {
                                    let p0 = CGPoint(x: src.posX * size.width * scale + offset.x,
                                                     y: src.posY * size.height * scale + offset.y)
                                    var path = Path(); path.move(to: p0); path.addLine(to: p1)
                                    ctx.stroke(path, with: .color(.secondary), lineWidth: 1)
                                }
                            }
                        }
                    }
                    // nodes
                    ForEach(viewStore.nodes) { node in
                        let p = CGPoint(x: node.posX * W * scale + offset.x,
                                        y: node.posY * H * scale + offset.y)
                        NodeView(
                            title: node.title,
                            sphere: node.sphere,
                            isUnlocked: viewStore.unlocked.contains(node.id),
                            isSelected: viewStore.selected == node.id
                        )
                        .position(p)
                        .onTapGesture { viewStore.send(.nodeTapped(node.id)) }
                        .onLongPressGesture { viewStore.send(.toggleUnlock(node.id)) }
                    }
                }
                .gesture(MagnificationGesture().onChanged { viewStore.send(.pinchChanged($0)) })
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { viewStore.send(.dragChanged($0.translation)) }
                    .onEnded { _ in viewStore.send(.dragEnded) })
                .onAppear { viewStore.send(.onAppear) }
            }
            .navigationTitle("Skill Tree")
        }
    }
}

private struct NodeView: View {
    let title: String
    let sphere: Sphere
    let isUnlocked: Bool
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .strokeBorder(isUnlocked ? Color.green : Color.gray, lineWidth: isSelected ? 4 : 2)
                .background(Circle().fill(color(for: sphere).opacity(0.2)))
                .frame(width: isSelected ? 56 : 44, height: isSelected ? 56 : 44)
            Text(title).font(.caption).multilineTextAlignment(.center).frame(width: 96)
        }
    }

    private func color(for s: Sphere) -> Color {
        switch s { case .runner: .blue; case .strength: .red; case .grappler: .orange; case .scout: .green }
    }
}
