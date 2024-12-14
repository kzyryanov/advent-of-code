//
//  Puzzle13ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-13.
//

import SwiftUI

@Observable
final class Puzzle13ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let variations = data(from: input)

        let buttonPresses: [(a: Int, b: Int)] = buttonPresses(from: variations)

        let tokens = buttonPresses.map { $0.a * 3 + $0.b }.reduce(0, +)

        return "\(tokens)"
    }

    func solveTwo(input: String) async -> String {
        let variations = data(from: input, prizeOffset: 10_000_000_000_000)

        let buttonPresses: [(a: Int, b: Int)] = buttonPresses(from: variations)

        let tokens = buttonPresses.map { $0.a * 3 + $0.b }.reduce(0, +)

        return "\(tokens)"
    }

    private func buttonPresses(from variations: [(x: Coeficient, y: Coeficient)]) -> [(a: Int, b: Int)] {
        variations.compactMap { variation in
            let b = (variation.x.a * variation.y.prize - variation.y.a * variation.x.prize) / (variation.x.a * variation.y.b - variation.y.a * variation.x.b)
            let a = (variation.x.prize - b * variation.x.b) / variation.x.a

            let isCorrectX = (variation.x.a * a + variation.x.b * b == variation.x.prize)
            let isCorrectY = (variation.y.a * a + variation.y.b * b == variation.y.prize)

            guard isCorrectX && isCorrectY else { return nil }
            return (a: a, b: b)
        }
    }

    private struct Coeficient {
        let a: Int
        let b: Int
        let prize: Int
    }

    private func data(from input: String, prizeOffset: Int = 0) -> [(x: Coeficient, y: Coeficient)] {
        let lines = input.lines.filter(\.isNotEmpty)

        let regexA = /Button A: X\+(?<x>\d+), Y\+(?<y>\d+)/
        let regexB = /Button B: X\+(?<x>\d+), Y\+(?<y>\d+)/
        let regexPrize = /Prize: X=(?<x>\d+), Y=(?<y>\d+)/

        let groupsCount = lines.count / 3

        var groups: [(x: Coeficient, y: Coeficient)] = []

        for group in 0..<groupsCount {
            let buttonA = lines[group * 3]
            let buttonB = lines[group * 3 + 1]
            let prize = lines[group * 3 + 2]

            guard let matchA = try? regexA.firstMatch(in: buttonA),
                  let matchB = try? regexB.firstMatch(in: buttonB),
                  let matchPrize = try? regexPrize.firstMatch(in: prize) else {
                fatalError()
            }

            let x = Coeficient(
                a: Int(matchA.output.x)!,
                b: Int(matchB.output.x)!,
                prize: Int(matchPrize.output.x)! + prizeOffset
            )

            let y = Coeficient(
                a: Int(matchA.output.y)!,
                b: Int(matchB.output.y)!,
                prize: Int(matchPrize.output.y)! + prizeOffset
            )
            
            groups.append((x, y))
        }

        return groups
    }
}
