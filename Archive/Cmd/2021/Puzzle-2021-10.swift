//
//  File.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-10.
//

import Foundation

func puzzle2021_10() {
    one()
    two()
}

fileprivate extension Character {
    var opposite: Character {
        switch self {
        case "]": return "["
        case "}": return "{"
        case ")": return "("
        case ">": return "<"
        case "[": return "]"
        case "{": return "}"
        case "(": return ")"
        case "<": return ">"
        default: fatalError("Invalid")
        }
    }

    var corruptScore: Int {
        switch self {
        case ")": return 3
        case "]": return 57
        case "}": return 1197
        case ">": return 25137
        default: fatalError("Invalid")
        }
    }

    var completeScore: Int {
        switch self {
        case ")": return 1
        case "]": return 2
        case "}": return 3
        case ">": return 4
        default: fatalError("Invalid")
        }
    }
}

fileprivate func one() {
    print("One")

    let input = puzzle2021_10_input()

    let score = input.reduce(0) { partialResult, chunk in
        var stack: [Character] = []
        for character in chunk {
            switch character {
            case "[", "{", "(", "<":
                stack.append(character)
            case "]", "}", ")", ">":
                if stack.last != character.opposite {
                    return partialResult + character.corruptScore
                }
                stack.removeLast()
            default:
                fatalError("Unknown character: \(character)")
            }
        }
        return partialResult
    }
    print(score)
}

fileprivate func two() {
    print("Two")

    let input = puzzle2021_10_input()

    let scores = input.compactMap { (chunk: String) -> Int? in
        var stack: [Character] = []
        for character in chunk {
            switch character {
            case "[", "{", "(", "<":
                stack.append(character)
            case "]", "}", ")", ">":
                if stack.last != character.opposite {
                    return nil
                }
                stack.removeLast()
            default:
                fatalError("Unknown character: \(character)")
            }
        }
        guard !stack.isEmpty else {
            return nil
        }
        return stack.reversed().reduce(0) { partialResult, character in
            partialResult * 5 + character.opposite.completeScore
        }
    }
        .sorted(by: <)

    if scores.isEmpty {
        fatalError()
    }

    print(scores[scores.count/2])
}
