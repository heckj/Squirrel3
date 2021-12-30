import XCTest
import Squirrel3
import CSquirrel

final class Squirrel3Tests: XCTestCase {
    func testExample() throws {
        var rng = PRNG(seed: 42)
        print(rng.next())
    }
}

//
//  PRNGTests.swift
//  - under Apache 2.0 license from https://github.com/maartene/Roguelike_iOS/

final class PRNGTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testFairness() throws {
        
        var rng = PRNG(seed: UInt64.random(in: 0 ..< 1_000_000))
        
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
        
        print("After \(flips) coin flips, we got \(heads). Expected: \(μ) Standard deviation: \(ɑ)")
        XCTAssert( ( μ - 2*ɑ ... μ + 2*ɑ).contains(Double(heads)) )
    }
    
    func testMinCycles() throws {
        var rng = PRNG(seed: UInt64.random(in: 0 ..< 1_000_000))
        
        let targetMinCycles = 1_000_000
        var results = Set<UInt64>()
        
        var collision = false
        var i = 0;
        while i < targetMinCycles && collision == false {
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
        var i: UInt64 = 0;
        while i < targetMinCycles && collision == false {
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
        self.measure {
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
