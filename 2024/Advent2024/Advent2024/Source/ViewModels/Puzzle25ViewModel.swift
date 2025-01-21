//
//  Puzzle25ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2025-01-20.
//

import SwiftUI

@Observable
final class Puzzle25ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    private struct Pair: Hashable {
        let lock: [Int]
        let key: [Int]
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let (locks, keys) = data(from: input)

        print(locks)
        print(keys)

        var pairs = Set<Pair>()

        for lock in locks {
            for key in keys {
                var fit = true
                for (i, p) in key.enumerated() {
                    if p + lock[i] > 5 {
                        fit = false
                        break
                    }
                }
                if fit {
                    pairs.insert(Pair(lock: lock, key: key))
                }
            }
        }

        for pair in pairs {
            print(pair.key, pair.lock)
        }
        return "\(pairs.count)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        return ""
    }

    private func data(from input: String) -> (locks: [[Int]], keys: [[Int]]) {
        let groups = input.split(separator: "\n\n")

        var keys: [[Int]] = []
        var locks: [[Int]] = []

        for keyLock in groups {
            let lines = keyLock.lines.filter(\.isNotEmpty)

            var parsingKey: Bool = false
            var parsingLock: Bool = false

            var keyLock = Array(repeating: 0, count: 5)

            for (index, line) in lines.enumerated() {
                switch line {
                case "#####" where !parsingKey && !parsingLock:
                    parsingLock = true
                case "....." where !parsingKey && !parsingLock:
                    parsingKey = true
                case "....." where parsingLock && index == lines.count - 1:
                    break
                case "#####" where parsingKey && index == lines.count - 1:
                    break
                default:
                    for (i, c) in line.enumerated() {
                        if c == "#" {
                            keyLock[i] += 1
                        }
                    }
                }
            }

            if parsingKey {
                keys.append(keyLock)
            }
            if parsingLock {
                locks.append(keyLock)
            }
        }


        return (locks, keys)
    }
}
