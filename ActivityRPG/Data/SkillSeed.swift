//
//  SkillSeed.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import SwiftData
import Foundation

@MainActor
enum SkillSeed {
    static func seedIfNeeded(container: ModelContainer) throws {
        let ctx = ModelContext(container)
        let count = try ctx.fetchCount(FetchDescriptor<SkillNode>())
        guard count == 0 else { return }

        let center = SkillNode()
        center.title = "Я"
        center.attribute = .agility
        center.posX = 0.5
        center.posY = 0.5
        center.cost = 0
        ctx.insert(center)

        func polar(_ angleDeg: Double, _ r: Double) -> (x: Double, y: Double) {
            let a = angleDeg * .pi / 180
            let x = 0.5 + cos(a) * r
            let y = 0.5 + sin(a) * r
            return (x, y)
        }

        @discardableResult
        func makeBranch(
            title: String,
            attribute: Attribute,
            angle: Double,
            steps: Int = 10,
            rStart: Double = 0.12,
            rEnd: Double = 0.45
        ) -> [SkillNode] {
            var out: [SkillNode] = []
            var prev: SkillNode? = nil

            for i in 1...steps {
                let t = Double(i) / Double(steps)
                let r = rStart + (rEnd - rStart) * t
                let (x, y) = polar(angle, r)

                let n = SkillNode()
                n.title = "\(title) \(i)"
                n.attribute = attribute
                n.posX = x
                n.posY = y
                n.cost = (i % 3 == 0) ? 2 : 1

                if let p = prev {
                    n.requires = [p.id]
                } else {
                    n.requires = [center.id]
                }

                ctx.insert(n)
                out.append(n)
                prev = n
            }


            if out.count >= 6 {
                out[5].requires.append(out[2].id)
            }
            if out.count >= 9 {
                out[8].requires.append(out[4].id)
            }

            return out
        }


        let agility = makeBranch(
            title: "Ловкость",
            attribute: .agility,
            angle: -90
        )
        let strength = makeBranch(
            title: "Сила",
            attribute: .strength,
            angle: 0
        )
        let flexibility = makeBranch(
            title: "Гибкость",
            attribute: .flexibility,
            angle: 180
        )
        let endurance = makeBranch(
            title: "Выносливость",
            attribute: .endurance,
            angle: 90
        )


        if agility.count > 3, strength.count > 3 {
            agility[3].requires.append(strength[2].id)
        }
        if flexibility.count > 4, endurance.count > 4 {
            flexibility[4].requires.append(endurance[3].id)
        }

        try ctx.save()
    }
}
