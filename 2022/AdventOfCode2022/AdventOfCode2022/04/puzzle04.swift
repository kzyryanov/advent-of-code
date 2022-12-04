//
//  puzzle04.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-04.
//

import Foundation

func puzzle04() {
    print("Test")
    print("One")
    one(input: testInput04)
    print("Two")
    two(input: testInput04)

    print("")
    print("Real")
    print("One")
    one(input: input04)
    print("Two")
    two(input: input04)
}

private func one(input: String) {
    let pairs = input.components(separatedBy: "\n")
    let result = pairs.map { pair in
        let rangesStrings = pair.components(separatedBy: ",")
        let ranges = rangesStrings
            .map { $0.components(separatedBy: "-").map { Int($0)! } }
            .map { $0[0]...$0[1] }
        return ranges[0].embraces(ranges[1]) || ranges[1].embraces(ranges[0])
    }
        .filter { $0 }

    print(result.count)
}

private func two(input: String) {
    let pairs = input.components(separatedBy: "\n")
    let result = pairs.compactMap { pair in
        let rangesStrings = pair.components(separatedBy: ",")
        let ranges = rangesStrings
            .map { $0.components(separatedBy: "-").map { Int($0)! } }
            .map { $0[0]...$0[1] }
        return ranges[0].intersection(ranges[1])
    }

    print(result.count)
}

private extension ClosedRange {
    func embraces(_ other: Self) -> Bool {
        return other.clamped(to: self) == other
    }
}

private extension ClosedRange {
    func intersection(_ other: Self) -> ClosedRange? {
        var lowerBound: Bound?
        var upperBound: Bound?

        if self.contains(other.lowerBound) {
            lowerBound = other.lowerBound
        }

        if self.contains(other.upperBound) {
            upperBound = other.upperBound
        }

        if other.contains(self.lowerBound) {
            lowerBound = self.lowerBound
        }

        if other.contains(self.upperBound) {
            upperBound = self.upperBound
        }

        guard let lowerBound, let upperBound else {
            return nil
        }
        return lowerBound...upperBound
    }
}
