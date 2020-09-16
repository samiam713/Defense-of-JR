import Foundation
import RealityKit

class Drumstick: Entity, HasCollision {
    static var model: Entity! = nil
    static func dealWith(model: Entity) {
        model.removeFromParent()
        if Self.model != nil {return}
        model.transform.translation = [0.02,-0.04,0.0]
        Self.model = model
    }
    
    required init() {
        super.init()
        self.addChild(Self.model.clone(recursive: true))
        self.collision = CollisionComponent(shapes: [ShapeResource.generateSphere(radius: 0.14)])
    }
}
