import XCTest
@testable import Squirrel3

final class Squirrel3Tests: XCTestCase {
    func testExample() throws {
        var rng = PRNG(seed: 42)
        print(rng.next())
    }
}
