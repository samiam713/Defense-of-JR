//
//  Projectile.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/10/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import RealityKit

class Projectile: Entity {
    static var model: Entity!
    
    static func dealWith(model: Entity) {
        model.removeFromParent()
        if Self.model != nil {return}
        model.transform.translation = [0.0,-0.055,0.0]
        Self.model = model
    }
    
    required init() {
        super.init()
        self.addChild(Self.model.clone(recursive: true))
    }
}
