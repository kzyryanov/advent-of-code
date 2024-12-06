//
//  Puzzle03ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-03.
//

import SwiftUI

@Observable
final class Puzzle03ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let regex = /mul\((?<one>\d+?),(?<two>\d+?)\)/

        let result = input.matches(of: regex)
            .map { match in
                let one = Int(match.output.one)!
                let two = Int(match.output.two)!

                return one * two
            }
            .reduce(0, +)

        return "\(result)"
    }

    func solveTwo(input: String) async -> String {
        let regex = /mul\((?<one>\d{1,3}?),(?<two>\d{1,3}}?)\)|do\(\)|don't\(\)/

        var result: Int = 0
        var skip: Bool = false
        for match in input.matches(of: regex) {
            switch match.0 {
            case "do()":
                skip = false
            case "don't()":
                skip = true
            case _ where skip == false:
                result += Int(match.output.one!)! * Int(match.output.two!)!
            default:
                break
            }
        }

        return "\(result)"
    }
}
