//
//  Reality.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/5/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import RealityKit

class Reality: NSObject, ObservableObject {

    let view: ARView
    enum State {
        case scanning
        case placing
        case placed(Simulator)
        
        func placing() -> Bool {
            switch self {
            case .placing:
                return true
            default:
                return false
            }
        }
    }
    @Published var state: State = .scanning
    override init() {
        self.view = .init(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
        
        super.init()
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        self.view.session.run(config, options: [.resetTracking,.resetSceneReconstruction,.removeExistingAnchors])
        addGestureRecognizer()
        setupOverlay()
    }
}

// messages
extension Reality {
    func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Reality.receiveTap(gesture:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func receiveTap(gesture: UITapGestureRecognizer) {
        
        let location = gesture.location(in: view)
        switch state {
        case .placed(let sim):
            if let entity = view.entity(at: location) {
                sim.receiveTap(entity: entity)
            }
        case .placing:
            place(location: location)
        case .scanning:
            return
        }
    }
    
    func place(location: CGPoint) {
        if let cast = view.raycast(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal).first {
            let root = AnchorEntity(raycastResult: cast)
            root.transform.scale*=0.4
            root.transform.rotation = simd_quatf.init(angle: Float.pi*0.5, axis: [0.0,1.0,0.0])*root.transform.rotation
            view.scene.addAnchor(root)
            let simulator = Simulator(root: root,parent: self)
            self.state = .placed(simulator)
        }
    }
}

// queries
extension Reality {
    func getSim()->Simulator? {
        switch state {
        case .placed(let simulator):
            return simulator
        default:
            return nil
        }
    }
}
