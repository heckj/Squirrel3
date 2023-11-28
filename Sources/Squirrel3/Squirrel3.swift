import CSquirrel
import Foundation
// This RNG function uses Squirrel Eiserloh's hash function to generate "random" numbers.

/// A Pseudo-random number generator that deterministically creates random numbers based on the seed you provide.
public struct PRNG: SeededRandomNumberGenerator {
    /// The current position of the pseudo-random number generator.
    public var position: UInt64

    /// The seed for the pseudo-random number generator.
    public let seed: UInt64

    /// Creates a new pseudo-random number generator.
    /// - Parameter seed: An unsigned integer seed value for the generator.
    public init(seed: UInt64) {
        self.seed = seed
        position = seed
    }

    /// Returns the next random UInt64 value.
    public mutating func next() -> UInt64 {
        position = Squirrel3(position)
        return position
    }
}

let BIT_NOISE1: UInt64 = 0xB529_7A4D_B529_7A4D
let BIT_NOISE2: UInt64 = 0x68E3_1DA4_68E3_1DA4
let BIT_NOISE3: UInt64 = 0x1B56_C4E9_1B56_C4E9

public func SwiftSquirrel3(_ position: UInt64) -> UInt64 {
    var mangled = position // make a copy
    mangled &*= BIT_NOISE1
    mangled ^= (mangled >> 8)
    mangled &+= BIT_NOISE2
    mangled ^= (mangled << 8)
    mangled &*= BIT_NOISE3
    mangled ^= (mangled >> 8)
    return mangled
}
