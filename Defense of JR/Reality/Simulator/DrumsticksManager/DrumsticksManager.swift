
import Foundation
import simd
import RealityKit

class DrumsticksManager {

    var drumsticks = Set<DrumstickManager>()
    
    unowned let parent: Simulator
    
    let lifetime: Float = 5.0
    let spawnPoints: [(SIMD3<Float>,simd_quatf)]
    let end: SIMD3<Float> = [0.0365,0.205,0.0]
    let orthog: [SIMD3<Float>] = [[0.0,0.0,0.2],[0.0,0.2,0.0],[0.0,-0.2,0.0],[0.0,0.0,-0.2]]
    var nextSpawn: Float = 2.0
    var spawnInterval: Float = 3.0
    
    var bodyCount = 0
    
    init(scene: Experience.Box, spawnPoints: [(SIMD3<Float>,simd_quatf)], parent: Simulator) {
        self.parent = parent
        self.spawnPoints = spawnPoints
        
        Drumstick.dealWith(model: scene.drumstick!)
    }
}

extension DrumsticksManager {
    func update(time: Float) {
        removeDead()
        for virus in drumsticks {
            if virus.update(time: time) {
                parent.endGame()
            }
        }
        dealWithSpawning(time: time)
    }
    func removeDead() {
        let newViruses = self.drumsticks.filter({$0.drumstick.parent != nil})
        bodyCount += (drumsticks.count-newViruses.count)
        self.drumsticks = newViruses
    }
    func dealWithSpawning(time: Float) {
        if time > nextSpawn {
            nextSpawn+=spawnInterval
            if spawnInterval > 1.0 {
                spawnInterval*=0.9
            } else {
                spawnInterval*=0.99
            }
            let newDrumstick = Drumstick()
            parent.root.addChild(newDrumstick)
            let start = spawnPoints.randomElement()!
            newDrumstick.transform.translation = start.0
            newDrumstick.transform.rotation = start.1 * newDrumstick.transform.rotation
            let manager = DrumstickManager(drumstick: newDrumstick, start: start.0, end: end, orthog: orthog.randomElement()!, startTime: time, endTime: time+lifetime)
            drumsticks.insert(manager)
        }
    }
}
