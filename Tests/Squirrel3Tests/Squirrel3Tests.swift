import CSquirrel
import Squirrel3
import TabularData
import XCTest

final class Squirrel3Tests: XCTestCase {
    func testCodeEquivalence() throws {
        XCTAssertEqual(9_812_080_132_662_924_994, Squirrel3(0))
        XCTAssertEqual(9_304_568_784_081_223_493, Squirrel3(1))
        XCTAssertEqual(4_400_162_391_327_569_318, Squirrel3(42))

        XCTAssertEqual(9_812_080_132_662_924_994, SwiftSquirrel3(0))
        XCTAssertEqual(SwiftSquirrel3(0), Squirrel3(0))
        XCTAssertEqual(SwiftSquirrel3(1), Squirrel3(1))
        XCTAssertEqual(SwiftSquirrel3(42), Squirrel3(42))
    }

    func testSeedConsistency() throws {
        let initialSeedValue: UInt64 = 42
        var rng = PRNG(seed: initialSeedValue)
        XCTAssertEqual(rng.seed, initialSeedValue)
        _ = rng.next()
        XCTAssertEqual(rng.seed, initialSeedValue)
    }

    func testPositionUpdates() throws {
        let initialSeedValue: UInt64 = 42
        var rng = PRNG(seed: initialSeedValue)
        XCTAssertEqual(rng.seed, initialSeedValue)
        XCTAssertEqual(rng.position, initialSeedValue)
        _ = rng.next()
        XCTAssertEqual(rng.seed, initialSeedValue)
        XCTAssertNotEqual(rng.position, initialSeedValue)
    }

    func testDeterminism() throws {
        let initialSeedValue: UInt64 = 42
        var rng = PRNG(seed: initialSeedValue)
        _ = rng.next()

        let currentPosition = rng.position
        let nextValue = rng.next()

        var newRNG = PRNG(seed: initialSeedValue)
        newRNG.position = currentPosition
        let secondNextValue = newRNG.next()

        XCTAssertEqual(nextValue, secondNextValue)
    }
}

//
//  PRNGTests.swift
//  - under Apache 2.0 license from https://github.com/maartene/Roguelike_iOS/

final class PRNGTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testFairnessReport() throws {
        var rng = PRNG(seed: 1_234_456_789)
        for _ in 1 ... 10 {
            var dataFrame = DataFrame()
            let flipsColumn = Column<Int>(name: "flips", capacity: 10)
            let headsColumn = Column<Int>(name: "heads", capacity: 10)
            let expectedColumn = Column<Double>(name: "μ", capacity: 10)
            let stdDevColumn = Column<Double>(name: "ɑ", capacity: 10)
            let fairnessColumn = Column<Bool>(name: "fair", capacity: 10)
            let rangeColumn = Column<String>(name: "range", capacity: 10)
            dataFrame.append(column: flipsColumn)
            dataFrame.append(column: headsColumn)
            dataFrame.append(column: expectedColumn)
            dataFrame.append(column: stdDevColumn)
            dataFrame.append(column: rangeColumn)
            dataFrame.append(column: fairnessColumn)

            let number_of_flips_to_check = [10, 100, 1000, 10000, 100_000, 1_000_000]

            for flips in number_of_flips_to_check {
                var heads: UInt64 = 0
                for _ in 0 ..< flips {
                    if Bool.random(using: &rng) {
                        heads += 1
                    }
                }

                let p = 0.5
                let μ = Double(flips) * p
                let ɑ = sqrt(Double(flips) * p * (1.0 - p))
                // fair range is within two standard deviations of the mean
                let fairRange = (μ - 2 * ɑ ... μ + 2 * ɑ)

                let isWithinFairRange = fairRange.contains(Double(heads))
                var valuesToAppend: [String: Any] = [:]
                valuesToAppend["flips"] = Int(flips)
                valuesToAppend["heads"] = Int(heads)
                valuesToAppend["μ"] = μ
                valuesToAppend["ɑ"] = ɑ
                valuesToAppend["range"] = String("\(fairRange)")
                valuesToAppend["fair"] = isWithinFairRange

                dataFrame.append(valuesByColumn: valuesToAppend)
            }
            print(dataFrame)
        }
    }

    func testFairness() throws {
        var rng = PRNG(seed: 1_234_456_789)

        let flips = 1_000_000
        var heads = 0
        for _ in 0 ..< flips {
            if Bool.random(using: &rng) {
                heads += 1
            }
        }

        let p = 0.5
        let μ = Double(flips) * p
        let ɑ = sqrt(Double(flips) * p * (1.0 - p))

        // print("After \(flips) coin flips, we got \(heads) results as 'heads'. Expected: \(μ) Standard deviation: \(ɑ)")
        let fairRange = (μ - 2 * ɑ ... μ + 2 * ɑ)
        XCTAssert(fairRange.contains(Double(heads)), "Fairness not within expected range: \(fairRange)")
    }

    func testMinCycles() throws {
        var rng = PRNG(seed: UInt64.random(in: 0 ..< 1_000_000))

        let targetMinCycles = 1_000_000
        var results = Set<UInt64>()

        var collision = false
        var i = 0
        while i < targetMinCycles, collision == false {
            let result = rng.next()
            if results.contains(result) {
                collision = true
            }
            results.insert(result)
            i += 1
        }

        XCTAssertEqual(results.count, targetMinCycles)
    }

    func testNotSameResult() throws {
        for x: UInt64 in 0 ... 1_000_000 {
            XCTAssertNotEqual(x, Squirrel3(x))
        }
    }

    func testNoCollisions() throws {
        let targetMinCycles = 1_000_000
        var results = Set<UInt64>()

        var collision = false
        var i: UInt64 = 0
        while i < targetMinCycles, collision == false {
            let result = Squirrel3(i)
            if results.contains(result) {
                collision = true
            }
            results.insert(result)
            i += 1
        }

        XCTAssertEqual(results.count, targetMinCycles)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        var pass = 0
        measure {
            pass += 1
            var rng = PRNG(seed: UInt64.random(in: 0 ..< 1_000_000))
            // Put the code you want to measure the time of here.
            // Generate a lot of bools

            var heads = 0
            for _ in 0 ..< 1_000_000 {
                if Bool.random(using: &rng) {
                    heads += 1
                }
            }

            print("Pass: \(pass) - number of heads: \(heads).")
        }
    }
}
