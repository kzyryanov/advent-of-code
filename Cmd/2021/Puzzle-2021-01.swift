//
//  Puzzle-2021-01.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-01.
//

import Foundation

func puzzle2021_01() {
    one()
    two()
}

fileprivate func one() {
    let input = puzzle2021_01_input()

    print("one: \(solve(input: input))")
}

fileprivate func two() {
    let input = puzzle2021_01_input()

    var converted: [Int] = []

    for index in 0..<input.count-2 {
        let window = input[index...index+2].reduce(0, +)
        converted.append(window)
    }

    print("two: \(solve(input: converted))")
}

fileprivate func solve(input: [Int]) -> Int {
    let result = input.reduce((result: 0, previousValue: nil)) { (partialResult: (result: Int, previousValue: Int?), value) in
        var result = partialResult.result
        if let previousValue = partialResult.previousValue, previousValue < value {
            result += 1
        }
        return (result, value)
    }
    return result.result
}
