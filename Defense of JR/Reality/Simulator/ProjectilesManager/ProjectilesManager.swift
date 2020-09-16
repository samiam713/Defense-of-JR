//
//  ProjectilesManager.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/6/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import RealityKit

extension simd_quatf {
    static let ident = simd_quatf.init(angle: 0.0, axis: [0.0,1.0,0.0])
}

class ProjectilesManager {

    unowned let parent: Simulator
    
    var projectiles = Set<ProjectileManager>()

    let srBody: Entity
    let srHead: Entity
    let cannonHole: Entity
    var bodyCount = 0
    let ogHeadRotation: simd_quatf
    let ogBodyRotation: simd_quatf
    
    init(scene: Experience.Box, parent: Simulator) {
        self.parent = parent
        
        srBody = scene.seniorBody!
        cannonHole = srBody.findEntity(named: "cannonHole")!
        srBody.removeFromParent()
        parent.root.addChild(srBody)
        ogBodyRotation = srBody.transform.rotation
        
        srHead = scene.seniorHead!
        srHead.removeFromParent()
        srBody.addChild(srHead)
        srHead.transform.translation = [0.0646,0.445,-0.1294]
        ogHeadRotation = srHead.transform.rotation
        
        Projectile.dealWith(model: scene.projectile!)
    }
}

extension ProjectilesManager {
    func update(dt:Float) {
        moveThenDelete(dt: dt)
        self.projectiles = self.projectiles.filter({$0.keepMe})
    }
    func moveThenDelete(dt: Float) {
        for projectile in projectiles {
            if projectile.target.parent == nil {
                projectile.projectile.removeFromParent()
                projectile.keepMe = false
                continue
            }
            projectile.approachTarget(dt: dt)
            if projectile.withinThreshold() {
                projectile.projectile.removeFromParent()
                projectile.target.removeFromParent()
                projectile.keepMe = false
            }
        }
    }
    func attack(drumstick: Entity) {
        let difference = drumstick.transform.translation - srBody.transform.translation
        let angle = atan(difference.z/difference.x)
        
        let bodyQuat = simd_quatf.init(angle: -angle, axis: [0.0,1.0,0.0])
        let headQuat = simd_quatf.init(angle: angle, axis: [0.0,1.0,0.0])
        
        srHead.transform.rotation = headQuat*ogHeadRotation
        srBody.transform.rotation = bodyQuat*ogBodyRotation
        
        let comparative = Transform(scale: .one, rotation: .ident, translation: [0.0, -0.0505, 0.0036])
        let inScene = cannonHole.convert(transform: comparative, to: parent.root)
        let spawner = Projectile()
        
        spawner.transform = inScene
        parent.root.addChild(spawner)
        projectiles.insert(ProjectileManager(projectile: spawner, target: drumstick))
    }
}
