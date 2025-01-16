//
//  Puzzle21ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-21.
//

import SwiftUI

@Observable
final class Puzzle21ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    private let pathHolder: PathHolder = PathHolder()

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let codes = data(from: input)

        typealias Sequence = (String, String)

        let sequences: [Sequence] = await withTaskGroup(of: Sequence.self) { group -> [Sequence] in
            for code in codes {
                group.addTask {
                    let s = await self.sequence(for: code, depth: 2)
                    return (code, s)
                }
            }

            return await group.reduce(into: []) { $0.append($1) }
        }

        let complexities = sequences.map { (code, sequence) in
            let number = Int(code.filter { $0.isNumber }) ?? 0
            return (number, sequence.count)
        }

        let result = complexities.map({ $0.0 * $0.1 }).reduce(0, +)

        return "\(result)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let codes = data(from: input)

        typealias Sequence = (String, Int)

        // 154115708116294 answer for example

        let complexities: [Sequence] = await withTaskGroup(of: Sequence.self) { group -> [Sequence] in
            for code in codes {
                group.addTask {
                    let s = await self.complexity(for: code, depth: 25)
                    return (code, s)
                }
            }

            return await group.reduce(into: []) { $0.append($1) }
        }

        print(complexities)

        let result = complexities.map { (code, complexity) in
            let number = Int(code.filter { $0.isNumber }) ?? 0
            return (number, complexity)
        }.map({ $0.0 * $0.1 }).reduce(0, +)

        return "\(result)"
    }

    private func sequence(for code: String, depth: Int) async -> String {
        var state: Character = "A"
        let codeArray = Array(code)

        var moves: [String] = []

        for index in 0..<codeArray.count {
            let to = codeArray[index]

            await moves.append(pathHolder.numpadPath(from: state, to: to))
            state = to
        }
        let numpadSequence = moves.joined()
        var padS: String = await padSequence(for: numpadSequence)
        for _ in 1..<depth {
            padS = await padSequence(for: padS)
        }

        return padS
    }

    private func complexity(for code: String, depth: Int) async -> Int {
        var state: Character = "A"
        let codeArray = Array(code)

        var moves: [String] = []

        for index in 0..<codeArray.count {
            let to = codeArray[index]

            await moves.append(pathHolder.numpadPath(from: state, to: to))
            state = to
        }
        let numpadSequence = moves.joined()
        let padS: String = await padSequence(for: numpadSequence)

        print(numpadSequence, padS)

        func splitSequence(_ string: String) -> [String] {
            let s = Array(string)
            var result: [String] = []

            var currentString = ""
            for c in s {
                currentString += String(c)
                if c == "A" {
                    result.append(currentString)
                    currentString = ""
                }
            }

            return result
        }

        var sequences = Dictionary(
            grouping: splitSequence(padS),
            by: { $0 })
            .mapValues { $0.count }

        var cache: [String: [String]] = [:]

        for _ in 1..<depth {
            var newSequences: [String: Int] = [:]
            for (sequence, count) in sequences {
                var converted: [String]! = cache[sequence]
                if nil == converted {
                    let s = await padSequence(for: sequence)
                    converted = splitSequence(s)
                    cache[sequence] = converted
                }

                let grouped = Dictionary(
                    grouping: converted,
                    by: { $0 })
                    .mapValues { $0.count }

                for (c, ccount) in grouped {
                    newSequences[c] = newSequences[c, default: 0] + count * ccount
                }
            }
            sequences = newSequences
        }

        return sequences.map { $0.key.count * $0.value }.reduce(0, +)

    }

    private func padSequence(for sequence: String) async -> String {
        var state: Character = "A"
        let codeArray = Array(sequence)

        var moves: [String] = []

        for index in 0..<codeArray.count {
            let to = codeArray[index]

            await moves.append(pathHolder.padPath(from: state, to: to))
            state = to
        }
        return moves.joined()
    }

    private func data(from input: String) -> [String] {
        let lines = input.lines.filter(\.isNotEmpty)

        return lines.map(String.init)
    }

    private actor PathHolder {
        private static let numpad: [Point: Character] = [
            Point(x: 0, y: 0): "7",
            Point(x: 1, y: 0): "8",
            Point(x: 2, y: 0): "9",
            Point(x: 0, y: 1): "4",
            Point(x: 1, y: 1): "5",
            Point(x: 2, y: 1): "6",
            Point(x: 0, y: 2): "1",
            Point(x: 1, y: 2): "2",
            Point(x: 2, y: 2): "3",
            Point(x: 1, y: 3): "0",
            Point(x: 2, y: 3): "A"
        ]

        static let directionsPad: [Point: Character] = [
            Point(x: 1, y: 0): "^",
            Point(x: 2, y: 0): "A",
            Point(x: 0, y: 1): "<",
            Point(x: 1, y: 1): "v",
            Point(x: 2, y: 1): ">"
        ]

        private static let reverseNumpad: [Character: Point] = Dictionary(uniqueKeysWithValues: numpad.map { ($0.value, $0.key) })
        private static let reverseDirectionsPad: [Character: Point] = Dictionary(uniqueKeysWithValues: directionsPad.map { ($0.value, $0.key) })

        private var numpadPath: [Character: [Character: String]] = [:]
        private var padPath: [Character: [Character: String]] = [:]

        func numpadPath(from: Character, to: Character) -> String {
            if let path = numpadPath[from]?[to] {
                return path
            }
            
            let sequence = path(from: from, to: to, in: Self.numpad, reversePad: Self.reverseNumpad, isNumpad: true)

            var storedPath = numpadPath[from, default: [:]]
            storedPath[to] = sequence
            numpadPath[from] = storedPath

            return sequence
        }

        func padPath(from: Character, to: Character) -> String {
            if let path = padPath[from]?[to] {
                return path
            }

            let sequence = path(from: from, to: to, in: Self.directionsPad, reversePad: Self.reverseDirectionsPad, isNumpad: false)

            var storedPath = padPath[from, default: [:]]
            storedPath[to] = sequence
            padPath[from] = storedPath

            return sequence
        }

        private func path(
            from: Character,
            to: Character,
            in pad: [Point: Character],
            reversePad: [Character: Point],
            isNumpad: Bool
        ) -> String {
            guard let fromPoint = reversePad[from], let toPoint = reversePad[to] else {
                assertionFailure("No character")
                return ""
            }

            if fromPoint == toPoint {
                return "A"
            }

            var result: [Character] = []

            let diffX = fromPoint.x - toPoint.x
            let diffY = fromPoint.y - toPoint.y

            let xMoves: Character = diffX < 0 ? ">" : "<"
            let yMoves: Character = diffY < 0 ? "v" : "^"

            let movingLeft = diffX > 0
            let movingRight = diffX < 0
            let movingDown = diffY < 0
            let movingUp = diffY > 0

            if isNumpad {

                let viaEmpty = (fromPoint.x == 0 && toPoint.y == 3) || (fromPoint.y == 3 && toPoint.x == 0)

                switch (movingLeft, movingRight, movingUp, movingDown, viaEmpty) {
                case (true, _, true, _, true): // left, up via empty
                    result += Array(repeating: yMoves, count: abs(diffY))
                    result += Array(repeating: xMoves, count: abs(diffX))
                case (_, true, _, true, true): // right, down via empty
                    result += Array(repeating: xMoves, count: abs(diffX))
                    result += Array(repeating: yMoves, count: abs(diffY))
                case (true, _, _, _, _): // left, up or down
                    result += Array(repeating: xMoves, count: abs(diffX))
                    result += Array(repeating: yMoves, count: abs(diffY))
                case (_, _, _, true, _): // left or right, down
                    result += Array(repeating: yMoves, count: abs(diffY))
                    result += Array(repeating: xMoves, count: abs(diffX))
                default:
                    result += Array(repeating: yMoves, count: abs(diffY))
                    result += Array(repeating: xMoves, count: abs(diffX))
                }
            } else {
                let viaEmpty = (fromPoint.x == 0 && toPoint.y == 0) || (fromPoint.y == 0 && toPoint.x == 0)

                switch (movingLeft, movingRight, movingUp, movingDown, viaEmpty) {
                case (true, _, _, true, true): // to <
                    result += Array(repeating: yMoves, count: abs(diffY))
                    result += Array(repeating: xMoves, count: abs(diffX))
                case (_, true, true, _, true): // from <
                    result += Array(repeating: xMoves, count: abs(diffX))
                    result += Array(repeating: yMoves, count: abs(diffY))
                case (_, true, _, _, _): // right, up
                    result += Array(repeating: yMoves, count: abs(diffY))
                    result += Array(repeating: xMoves, count: abs(diffX))
                default:
                    result += Array(repeating: xMoves, count: abs(diffX))
                    result += Array(repeating: yMoves, count: abs(diffY))
                }
            }

            return String(result + ["A"])
        }
    }
}

private extension Direction {
    var code: Character {
        switch self {
        case .left: "<"
        case .right: ">"
        case .up: "^"
        case .down: "v"
        default: "-"
        }
    }
}
