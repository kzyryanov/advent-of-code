//
//  Puzzle19ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-19.
//

import SwiftUI

@Observable
final class Puzzle19ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    private func possibleDesigns(input: String) -> [String] {
        let (towels, designs) = data(from: input)

        let possibleDesigns = designs.filter { design in
            var tails: Set<String> = [design]

            var checkedSuffixes: Set<String> = []

            while tails.isNotEmpty {
                let tail = tails.removeFirst()

                for towel in towels {
                    if tail == towel {
                        return true
                    }
                    if tail.hasPrefix(towel) {
                        let suffix = String(tail.suffix(tail.count - towel.count))
                        if !checkedSuffixes.contains(suffix) {
                            tails.insert(suffix)
                        }
                        checkedSuffixes.insert(suffix)
                    }
                }
            }

            return false
        }

        return possibleDesigns
    }

    private func possibleDesignsCounts(input: String) async -> Int {
        let (towels, designs) = data(from: input)

        let possibleDesigns = await withTaskGroup(of: Int.self) { group in
            for design in designs {
                group.addTask {
                    var tails: Set<String> = [design]

                    var tree: [String: Set<String>] = [:]
                    var reverseTree: [String: Set<String>] = [:]

                    while tails.isNotEmpty {
                        let tail = tails.removeFirst()

                        for towel in towels {
                            if tail == towel {
                                tree[""] = tree["", default: []].union([tail])
                                reverseTree[tail] = reverseTree[tail, default: []].union([""])
                                continue
                            }
                            if tail.hasPrefix(towel) {
                                let suffix = String(tail.suffix(tail.count - towel.count))
                                if tree[suffix] == nil {
                                    tails.insert(suffix)
                                }
                                tree[suffix] = tree[suffix, default: []].union([tail])
                                reverseTree[tail] = reverseTree[tail, default: []].union([suffix])
                            }
                        }
                    }

                    guard tree[""] != nil else {
                        return 0
                    }

                    var counts: [String: Int] = [:]

                    func countPaths(leaf: String) -> Int {
                        if leaf == "" {
                            return 1
                        }

                        if let count = counts[leaf] {
                            return count
                        }

                        let parents = reverseTree[leaf, default: []]
                        let count = parents.reduce(0) { acc, parent in
                            acc + countPaths(leaf: parent)
                        }
                        counts[leaf] = count
                        return count
                    }

                    let count = countPaths(leaf: design)

                    return max(1, count)
                }
            }
            return await group.reduce(0) { partialResult, value in
                partialResult + value
            }
        }

        return possibleDesigns
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let possibleDesigns = possibleDesigns(input: input)

        return "\(possibleDesigns.count)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let possibleDesignsCounts = await possibleDesignsCounts(input: input)

        return "\(possibleDesignsCounts)"
    }

    private func data(from input: String) -> (towels: Set<String>, designs: [String]) {
        var lines = input.lines.filter(\.isNotEmpty).map(String.init)

        let towels = lines.removeFirst().split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        let designs = lines.filter(\.isNotEmpty)

        return (Set(towels), designs)
    }
}
