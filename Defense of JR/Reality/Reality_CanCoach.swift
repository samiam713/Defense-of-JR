//
//  Reality_Thing.swift
//  Defense Of JR
//
//  Created by Samuel Donovan on 5/8/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import RealityKit

extension Reality: ARCoachingOverlayViewDelegate {
    func setupOverlay() {
        let overlay = ARCoachingOverlayView()
        overlay.session = view.session
        overlay.delegate = self
        
        view.addSubview(overlay)
        
        overlay.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            overlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            overlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            overlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        overlay.activatesAutomatically = true
        overlay.goal = .horizontalPlane
    }
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        switch state {
        case .placed(let sim):
            sim.pauseSim()
        default:
            state = .scanning
        }
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        switch state {
        case .scanning:
            state = .placing
        case .placing:
            return
        case .placed(_):
            return
        }
    }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        self.view.session.run(config, options: [.resetTracking,.resetSceneReconstruction,.removeExistingAnchors])
        state = .scanning
    }
}
