import GameplayKit

class SeededRandomNumberGenerator: RandomNumberGenerator {
    let seed: UInt64
    private let source: GKMersenneTwisterRandomSource
    
    init(seed: UInt64 = 0) {
        self.seed = seed
        source = GKMersenneTwisterRandomSource(seed: seed)
    }
    
    func next() -> UInt64 {
        // GKRandom produces values in [INT32_MIN, INT32_MAX] range; hence we need two numbers to produce 64-bit value.
        let next1 = UInt64(bitPattern: Int64(source.nextInt()))
        let next2 = UInt64(bitPattern: Int64(source.nextInt()))
        return next1 ^ (next2 << 32)
    }
}
