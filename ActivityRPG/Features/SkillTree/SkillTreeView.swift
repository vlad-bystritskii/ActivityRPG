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

    @GestureState private var drag: CGSize = .zero
    @GestureState private var pinch: CGFloat = 1.0
    @State private var baseOffset: CGPoint = .zero
    @State private var baseScale: Double = 1.0

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { proxy in
                Color.clear.onAppear {
                    baseOffset = viewStore.offset
                    baseScale  = viewStore.scale
                }
                .onChange(of: viewStore.offset) { _, offset in
                    baseOffset = offset
                }
                .onChange(of: viewStore.scale) { _, scale in
                    baseScale = scale
                }

                let currentScale  = (baseScale * pinch).clamped(0.5, 2.0)
                let currentOffset = CGPoint(
                    x: baseOffset.x + drag.width,
                    y: baseOffset.y + drag.height
                )

                let transform = CGAffineTransform.identity
                    .scaledBy(x: currentScale, y: currentScale)
                    .translatedBy(x: currentOffset.x, y: currentOffset.y)

                ZStack {
                    Canvas { ctx, size in
                        let nodes = viewStore.nodes
                        let map = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0) })
                        for node in nodes {
                            let p1 = CGPoint(x: node.posX * size.width,
                                             y: node.posY * size.height)
                            for req in node.requires {
                                if let src = map[req] {
                                    let p0 = CGPoint(x: src.posX * size.width,
                                                     y: src.posY * size.height)
                                    var path = Path(); path.move(to: p0); path.addLine(to: p1)
                                    ctx.stroke(path, with: .color(.secondary), lineWidth: 1)
                                }
                            }
                        }
                    }
                    .allowsHitTesting(false)
                    .transaction { $0.animation = nil }

                    ForEach(viewStore.nodes) { node in
                        let p = CGPoint(
                            x: node.posX * proxy.size.width,
                            y: node.posY * proxy.size.height
                        )
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
                .transformEffect(transform)
                .contentShape(Rectangle())
                .transaction { $0.animation = nil }

                .simultaneousGesture(
                    MagnificationGesture()
                        .updating($pinch) { value, state, _ in state = value }
                        .onEnded { value in
                            let v = (baseScale * value).clamped(0.5, 2.0)
                            baseScale = v
                            viewStore.send(.commitScale(v))
                        }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 3)
                        .updating($drag) { value, state, _ in state = value.translation }
                        .onEnded { value in
                            baseOffset.x += value.translation.width
                            baseOffset.y += value.translation.height
                            viewStore.send(.commitPan(baseOffset))
                        }
                )
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
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .frame(width: 96)
        }
        .transaction { $0.animation = nil }
    }

    private func color(for s: Sphere) -> Color {
        switch s {
        case .agility:
            return Color.blue
        case .strength:
            return Color.red
        case .flexibility:
            return Color.green
        case .endurance:
            return Color.orange
        }
    }
}

private extension Comparable {
    func clamped(_ a: Self, _ b: Self) -> Self {
        let low = min(a, b), high = max(a, b)
        return min(max(self, low), high)
    }
}
