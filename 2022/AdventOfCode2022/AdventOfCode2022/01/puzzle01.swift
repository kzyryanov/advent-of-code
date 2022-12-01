//
//  puzzle01.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-01.
//

import Foundation

func puzzle01() {
    one()
    two()
}

@discardableResult
private func one() -> [Int] {
    let paragraphs = input01.components(separatedBy: "\n")
    let food = paragraphs.reduce([0]) { partialResult, amount in
        if amount.isEmpty {
            return partialResult + [0]
        }
        var partialResult = partialResult
        partialResult[partialResult.endIndex - 1] += Int(amount)!
        return partialResult
    }
    print("Max food: ", food.max()!)
    return food
}

private func two() {
    let food = one().sorted()
    print("Top three sum: ", food.suffix(3).reduce(0, +))
}
