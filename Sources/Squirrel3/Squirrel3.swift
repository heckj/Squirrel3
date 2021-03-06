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
