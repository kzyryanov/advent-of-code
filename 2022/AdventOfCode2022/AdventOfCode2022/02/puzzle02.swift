//
//  puzzle02.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-02.
//

import Foundation

func puzzle02() {
    one()
    two()
}

private enum RPS {
    case rock
    case paper
    case scissors

    init(puzzleOne: String) {
        switch puzzleOne {
        case "A", "X": self = .rock
        case "B", "Y": self = .paper
        case "C", "Z": self = .scissors
        default:
            fatalError(puzzleOne)
        }
    }

    init(opponent: String, you: String) {
        let opponent = RPS(puzzleOne: opponent)
        switch you {
        case "X": self = opponent.wld.wins // you should lose
        case "Y": self = opponent.wld.draw // draw
        case "Z": self = opponent.wld.loses // win
        default: fatalError("\(opponent), \(you)")
        }
    }

    var value: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }

    var wld: (wins: RPS, loses: RPS, draw: RPS) {
        switch self {
        case .rock: return (.scissors, .paper, .rock)
        case .paper: return (.rock, .scissors, .paper)
        case .scissors: return (.paper, .rock, .scissors)
        }
    }

    static func score(opponent: Self, you: Self) -> Int {
        if opponent == you {
            return you.value + 3
        }

        if opponent < you {
            return you.value + 6
        }

        return you.value
    }
}

extension RPS: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.rock, .paper): return true
        case (.paper, .scissors): return true
        case (.scissors, .rock): return true
        default: return false
        }
    }
}

private func one() {
    let input = input02

    let score = input.components(separatedBy: "\n")
        .filter { !$0.isEmpty }
        .map { s in
            let components = s.components(separatedBy: " ")
            let round = (opponent: RPS(puzzleOne: components[0]), you: RPS(puzzleOne: components[1]))
            let score = RPS.score(opponent: round.opponent, you: round.you)
            return score
        }
        .reduce(0, +)

    print(score)
}

private func two() {
    let input = input02

    let score = input.components(separatedBy: "\n")
        .filter { !$0.isEmpty }
        .map { s in
            let components = s.components(separatedBy: " ")
            let opponent = components[0]
            let you = components[1]
            let round = (opponent: RPS(puzzleOne: opponent), you: RPS(opponent: opponent, you: you))
            let score = RPS.score(opponent: round.opponent, you: round.you)
            return score
        }
        .reduce(0, +)

    print(score)
}
