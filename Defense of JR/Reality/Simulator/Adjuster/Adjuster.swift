//
//  EntityStore.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/6/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import RealityKit

class Adjuster {

    unowned let parent: Simulator
    
    let play: Entity
    
    let bigger: Entity
    let smaller: Entity
    
    let up: Entity
    let right: Entity
    let down: Entity
    let left: Entity
    
    let rotateRight: Entity
    let rotateLeft: Entity
    
    var r: SIMD3<Float> = [0.1,0.0,0.0]
    var d: SIMD3<Float> = [0.0,0.0,0.1]
    var l: SIMD3<Float> = [-0.1,0.0,0.0]
    var u: SIMD3<Float> = [0.0,0.0,-0.1]
    
    init(experience: Experience.Box, parent: Simulator) {
        
        self.parent = parent
        
        play = experience.play!
        play.removeFromParent()
        parent.root.addChild(play)
        
        bigger = experience.bigger!
        bigger.removeFromParent()
        parent.root.addChild(bigger)
        
        smaller = experience.smaller!
        smaller.removeFromParent()
        parent.root.addChild(smaller)
        
        up = experience.up!
        up.removeFromParent()
        parent.root.addChild(up)
        
        right = experience.right!
        right.removeFromParent()
        parent.root.addChild(right)
        
        down = experience.down!
        down.removeFromParent()
        parent.root.addChild(down)
        
        left = experience.left!
        left.removeFromParent()
        parent.root.addChild(left)
        
        rotateRight = experience.rotateRight!
        rotateRight.removeFromParent()
        parent.root.addChild(rotateRight)
        
        rotateLeft = experience.rotateLeft!
        rotateLeft.removeFromParent()
        parent.root.addChild(rotateLeft)
        
    }
    
}

extension Adjuster {
    func receivePausedTap(entity: Entity) {
        switch entity {
        case play:
            parent.playSim()
        case bigger:
            parent.root.transform.scale*=1.2
            l*=1.2
            u*=1.2
            r*=1.2
            d*=1.2
        case smaller:
            parent.root.transform.scale/=1.2
            l/=1.2
            u/=1.2
            r/=1.2
            d/=1.2
        case right:
            parent.root.transform.translation += r
        case down:
            parent.root.transform.translation += d
        case left:
            parent.root.transform.translation += l
        case up:
            parent.root.transform.translation += u
        case rotateRight:
            let rotator = simd_quatf.init(angle: -15.0*Float.degreeShrinker, axis: [0.0,1.0,0.0])
            parent.root.transform.rotation = rotator*parent.root.transform.rotation
            l = rotator.act(l)
            u = rotator.act(u)
            r = rotator.act(r)
            d = rotator.act(d)
        case rotateLeft:
            let rotator = simd_quatf.init(angle: 15.0*Float.degreeShrinker, axis: [0.0,1.0,0.0])
            parent.root.transform.rotation = rotator*parent.root.transform.rotation
            l = rotator.act(l)
            u = rotator.act(u)
            r = rotator.act(r)
            d = rotator.act(d)
        default:
            return
        }
    }
}
