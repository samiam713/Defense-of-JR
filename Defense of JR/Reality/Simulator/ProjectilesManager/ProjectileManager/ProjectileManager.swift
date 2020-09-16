//
//  ProjectileManager.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/6/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import RealityKit

class ProjectileManager: Identifiable, Hashable {
    
    static func == (lhs: ProjectileManager, rhs: ProjectileManager) -> Bool {lhs.id==rhs.id}
    func hash(into hasher: inout Hasher) {hasher.combine(self.id)}
    
    let projectile: Entity
    let target: Entity
    let speed: Float = 1.0
    var keepMe = true
    
    init(projectile: Entity, target: Entity) {
        self.projectile = projectile
        self.target = target
    }
}

extension ProjectileManager {
    func approachTarget(dt:Float) {
        let direction = simd_normalize(target.transform.translation - projectile.transform.translation)
        projectile.transform.translation += direction*(dt*speed)
    }
}

extension ProjectileManager {
    func withinThreshold()->Bool {
        let dsqr = simd_distance_squared(projectile.transform.translation, target.transform.translation)
        return dsqr < 0.01
    }
}
