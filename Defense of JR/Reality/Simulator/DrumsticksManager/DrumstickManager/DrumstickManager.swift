import Foundation
import RealityKit

class DrumstickManager: Identifiable, Hashable {
    static func == (lhs: DrumstickManager, rhs: DrumstickManager) -> Bool {lhs.id==rhs.id}
    func hash(into hasher: inout Hasher) {hasher.combine(self.id)}
    
    let drumstick: Entity
    let start: SIMD3<Float>
    let end: SIMD3<Float>
    let orthog: SIMD3<Float>
    let startTime: Float
    let endTime: Float
    
    init(drumstick: Entity, start: SIMD3<Float>, end: SIMD3<Float>, orthog: SIMD3<Float>, startTime: Float, endTime: Float) {
        self.drumstick = drumstick
        self.start = start
        self.end = end
        self.orthog = orthog
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension DrumstickManager {
    // returns true if the game's over
    func update(time: Float)->Bool {
        if time > endTime {return true}
        let proportion = (time-startTime)/(endTime-startTime)
        let comp0 = simd_mix(start,end,.init(repeating: proportion))
        let sinFactor = simd_mix(Float.zero,4*Float.pi,proportion)
        let comp1 = orthog*sin(sinFactor)
        drumstick.transform.translation = comp0 + comp1
        return false
    }
}
