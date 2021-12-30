import Foundation
import CSquirrel
// This RNG function uses Squirrel Eiserloh's hash function to generate "random" numbers.


/// A Pseudo-random number generator that deterministically creates random numbers based on the seed you provide.
public struct PRNG: RandomNumberGenerator {
    /// The seed for the pseudo-random number generator.
    public var seed: UInt64
    
    /// Creates a new pseudo-random number generator.
    /// - Parameter seed: An unsigned integer seed value for the generator.
    public init(seed: UInt64) {
        self.seed = seed
    }
    
    /// Returns the next random UInt64 value.
    public mutating func next() -> UInt64 {
        seed = Squirrel3(seed)
        return seed
    }
}
