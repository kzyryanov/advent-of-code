//
//  Puzzle03ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-03.
//

import SwiftUI

@Observable
final class Puzzle03ViewModel: PuzzleViewModel {
    var answer: Answer = Answer()

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

    enum Match {
        case numbers(index: String.Index, one: Int, two: Int)
        case `do`(index: String.Index)
        case dont(index: String.Index)

        var index: String.Index {
            switch self {
            case .numbers(let index, _, _): return index
            case .do(let index): return index
            case .dont(let index): return index
            }
        }
    }

    func solveTwo(input: String) async -> String {
        let regex = /mul\((?<one>\d+?),(?<two>\d+?)\)/
        let doRegex = /do\(\)/
        let dontRegex = /don't\(\)/

        let dos = input.matches(of: doRegex).map {
            Match.do(index: $0.startIndex)
        }
        let donts = input.matches(of: dontRegex).map {
            Match.dont(index: $0.startIndex)
        }
        let matches = input.matches(of: regex).map {
            Match.numbers(index: $0.range.lowerBound, one: Int($0.output.one)!, two: Int($0.output.two)!)
        }

        let allMatches = (dos + donts + matches).sorted(by: { $0.index < $1.index })

        var result: Int = 0
        var skip: Bool = false
        for match in allMatches {
            switch match {
            case let .numbers(_, one, two) where !skip:
                result += (one * two)
            case .do:
                skip = false
            case .dont:
                skip = true
            default: break
            }
        }

        return "\(result)"
    }
}
