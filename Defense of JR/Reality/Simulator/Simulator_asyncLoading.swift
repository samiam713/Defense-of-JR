//
//  Simulator_asyncLoading.swift
//  Defense Of JR
//
//  Created by Samuel Donovan on 5/9/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import RealityKit

extension Simulator {
    func uponLoading(experience: Experience.Box) {

        let people = [experience.p1!,experience.p2!,experience.p3!,experience.p4!,experience.p5!].shuffled()
        
        let degrees: [Float] = [-40,-20,0,20,40].map({$0*Float.degreeShrinker})
        let quaternions: [simd_quatf] = degrees.map({simd_quatf.init(angle: $0, axis: [0.0,1.0,0.0])})
        let translations: [SIMD3<Float>] = quaternions.map({$0.act([1.5,0.0,0.0])})
        let spawnPoints: [(SIMD3<Float>,simd_quatf)] = quaternions.map({($0.act([1.42,0.58,0.0]),$0)})
        
        for i in 0..<5 {
            people[i].transform.translation = translations[i]
            people[i].transform.rotation = quaternions[i]*people[i].transform.rotation
            people[i].removeFromParent()
            root.addChild(people[i])
        }
        
        let jr = experience.junior!
        jr.removeFromParent()
        root.addChild(jr)
        
        self.pause = experience.pause!
        pause.removeFromParent()
        root.addChild(pause)
        pause.isEnabled = false
        
        adjuster = .init(experience: experience, parent: self)
        projectilesManager = .init(scene: experience, parent: self)
        drumsticksManager = .init(scene: experience, spawnPoints: spawnPoints, parent: self)
        
        let publisher = parent.view.scene.publisher(for: SceneEvents.Update.self)
        
        self.publisher = publisher.sink(receiveValue: {[unowned self] in self.receive($0)})
    }
    
    func uponLoading(audio: AudioFileResource) {
        self.audioController = root.playAudio(audio)
        if paused {
            audioController!.pause()
        } else {
            audioController!.play()
        }
        audioLoader?.cancel()
    }
}
