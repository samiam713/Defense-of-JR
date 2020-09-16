//
//  Simulator.swift
//  COVID19 Simulator
//
//  Created by Samuel Donovan on 4/5/20.
//  Copyright © 2020 Samuel Donovan. All rights reserved.
//

import Foundation
import RealityKit
import Combine

extension Float  {
    static let degreeShrinker: Float = (Float.pi/180.0)
}

class Simulator {
    deinit {
        publisher.cancel()
    }
    unowned let parent: Reality
    
    let root: AnchorEntity
    var paused=true
    
    var adjuster: Adjuster! = nil
    var projectilesManager: ProjectilesManager! = nil
    var drumsticksManager: DrumsticksManager! = nil
    var publisher: AnyCancellable! = nil
    var audioController: AudioPlaybackController? = nil
        
    var pause: Entity! = nil
    
    var time: Float = 0.0
    
    var audioLoader: AnyCancellable? = nil
    
    init(root: AnchorEntity, parent: Reality) {
        self.root = root
        self.parent = parent
        
        Experience.loadBoxAsync(completion: {
            switch $0 {
            case .success(let box):
                self.uponLoading(experience: box)
            case .failure(_):
                fatalError()
            }})
        
        let loadRequest = AudioFileResource.loadAsync(named: "AllTimeHighJump.mp3", inputMode: .nonSpatial, shouldLoop: true)
        self.audioLoader = loadRequest.sink(receiveCompletion: {switch $0 {
        case .finished:
            return
        case .failure(_):
            fatalError()
            }}, receiveValue: uponLoading(audio:))
    }
}

// messages
extension Simulator {
    func receiveTap(entity: Entity) {
        if paused {
            adjuster.receivePausedTap(entity: entity)
        } else {
            receivePlayingTap(entity: entity)
        }
    }
    func pauseSim() {
        self.paused = true
        self.pause?.isEnabled = false
        adjuster?.play.isEnabled = true
        self.audioController?.pause()
    }
    
    func playSim() {
        self.paused = false
        self.pause?.isEnabled = true
        adjuster?.play.isEnabled = false
        self.audioController?.play()
    }
    
    func receivePlayingTap(entity: Entity) {
        if entity is Drumstick {
            projectilesManager.attack(drumstick: entity)
        } else if entity == pause {
            pauseSim()
        }
    }
    func endGame() {
        publisher.cancel()
        parent.view.snapshot(saveToHDR: false) {[count = self.drumsticksManager.bodyCount] image in
            AppController.singleton.toVictoryView(image: image!, count: count)
        }
        adjuster = nil
           projectilesManager = nil
           drumsticksManager = nil
    }
    func receive(_ input: SceneEvents.Update) {
        if paused {return}
        let dt = Float(input.deltaTime)
        time+=dt
        
        projectilesManager.update(dt: dt)
        drumsticksManager.update(time: time)
    }
}

extension Simulator {
    func gameScale()->Float {
        return root.transform.scale.x
    }
}
