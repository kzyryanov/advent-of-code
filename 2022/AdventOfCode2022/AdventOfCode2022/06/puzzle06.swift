//
//  puzzle06.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-06.
//

import Foundation

func puzzle06() {
    print("Test")
    print("One")
    testInput06.forEach {
        print(one(input: $0))
    }
    print("Two")
    testInput06.forEach {
        print(two(input: $0))
    }

    print("")
    print("Real")
    print("One")
    print(one(input: input06))
    print("Two")
    print(two(input: input06))
}

private func one(input: String, windowLength: Int = 4) -> Int {
    let input = Array(input)
    for index in 0..<(input.count - windowLength) {
        let marker = input[index..<(index + windowLength)]
        if Set(marker).count == windowLength {
            return index + windowLength
        }
    }
    return -1
}

private func two(input: String) -> Int {
    return one(input: input, windowLength: 14)
}
