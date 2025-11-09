//
//  SkillSeed.swift
//  ActivityRPG
//
//  Created by Vladislav Bystritskii on 08/11/2025.
//

import SwiftData

enum SkillSeed {
    static func seedIfNeeded(container: ModelContainer) throws {
        let ctx = ModelContext(container)
        let count = try ctx.fetchCount(FetchDescriptor<SkillNode>())
        guard count == 0 else { return }

        let r0 = SkillNode(title: "Путь Бегуна", sphere: .runner,   posX: 0.15, posY: 0.50)
        let r1 = SkillNode(title: "+2% к темпу", sphere: .runner,    posX: 0.25, posY: 0.40, requires: [r0.id])
        let r2 = SkillNode(title: "+3 выносливости", sphere: .runner,posX: 0.25, posY: 0.60, requires: [r0.id])

        let s0 = SkillNode(title: "Путь Силы", sphere: .strength,    posX: 0.50, posY: 0.80)
        let s1 = SkillNode(title: "+1 к силе", sphere: .strength,    posX: 0.60, posY: 0.78, requires: [s0.id])

        let g0 = SkillNode(title: "Путь Борца", sphere: .grappler,   posX: 0.80, posY: 0.55)
        let g1 = SkillNode(title: "+ловкость", sphere: .grappler,    posX: 0.70, posY: 0.50, requires: [g0.id])

        let sc0 = SkillNode(title: "Путь Следопыта", sphere: .scout, posX: 0.45, posY: 0.20)
        let sc1 = SkillNode(title: "+ориентирование", sphere: .scout,posX: 0.55, posY: 0.22, requires: [sc0.id])

        let b1 = SkillNode(title: "Подвижность", sphere: .runner, posX: 0.40, posY: 0.45, cost: 2, requires: [r1.id, s0.id])
        let b2 = SkillNode(title: "Выносливость клинча", sphere: .grappler, posX: 0.65, posY: 0.60, cost: 2, requires: [s1.id, g0.id])

        [r0,r1,r2,s0,s1,g0,g1,sc0,sc1,b1,b2].forEach { ctx.insert($0) }
        try ctx.save()
    }
}
