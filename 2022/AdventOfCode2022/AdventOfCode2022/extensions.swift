//
//  extensions.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-05.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
}

extension ClosedRange {
    func embraces(_ other: Self) -> Bool {
        return other.clamped(to: self) == other
    }

    func intersection(_ other: Self) -> ClosedRange? {
        if lowerBound > other.upperBound || other.lowerBound > upperBound {
            return nil
        }

        return Swift.max(lowerBound, other.lowerBound)...Swift.min(upperBound, other.upperBound)
    }

    func union(_ other: Self) -> ClosedRange? {
        guard nil != intersection(other) else {
            return nil
        }
        return Swift.min(self.lowerBound, other.lowerBound)...Swift.max(self.upperBound, other.upperBound)
    }
}
