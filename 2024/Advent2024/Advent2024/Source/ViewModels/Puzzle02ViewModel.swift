//
//  Puzzle02ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-02.
//

import SwiftUI

@Observable
final class Puzzle02ViewModel: PuzzleViewModel {
    var answer: Answer = Answer()

    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        return ""
    }

    func solveTwo(input: String) async -> String {
        return ""
    }

    func data(from input: String) -> [[Int]] {
        let lines = input.lines.filter(\.isNotEmpty)

        return []
    }
}
