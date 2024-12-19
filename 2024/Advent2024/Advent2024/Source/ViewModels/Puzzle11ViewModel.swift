//
//  Puzzle11ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-11.
//

import SwiftUI

@Observable
final class Puzzle11ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let stones = input
            .split(separator: " ")
            .filter(\.isNotEmpty)
            .map { Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! }

        let result = blink(with: stones, for: 25)

        return "\(result)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let stones = input
            .split(separator: " ")
            .filter(\.isNotEmpty)
            .map { Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! }

        let result = blink(with: stones, for: 75)

        return "\(result)"
    }

    private func blink(with stones: [Int], for iterations: Int) -> Int {
        var dict = Dictionary(grouping: stones, by: { $0 }).mapValues(\.count)

        for _ in 1...iterations {
            var newDict: [Int: Int] = [:]

            for (stone, count) in dict {
                let stringStone = "\(stone)"
                let length = stringStone.count

                if stone == 0 {
                    newDict[1] = newDict[1, default: 0] + count
                } else if length % 2 == 0 {
                    let half = length / 2
                    let stone1 = Int(stringStone.prefix(half))!
                    let stone2 = Int(stringStone.suffix(half))!

                    newDict[stone1] = newDict[stone1, default: 0] + count
                    newDict[stone2] = newDict[stone2, default: 0] + count
                } else {
                    let newStone = stone * 2024
                    newDict[newStone] = newDict[newStone, default: 0] + count
                }
            }

            dict = newDict
        }

        return dict.values.reduce(0, +)
    }
}
